require 'rails_helper'
require 'json'

RSpec.describe SendNotificationsJob, type: :job do
  let(:user) { create(:user) }
  let!(:session1) { create(:session, user: user, push_endpoint: "http://example.com/1", push_p256dh: "p256dh1", push_auth: "auth1") }
  let!(:session2) { create(:session, user: user, push_endpoint: "http://example.com/2", push_p256dh: "p256dh2", push_auth: "auth2") }
  let(:title) { "Test Title" }
  let(:body)  { "Test Body" }
  let(:icon)  { "http://example.com/icon.png" }
  let(:link)  { "http://example.com" }

  before do
    # Create a more flexible ENV stub that returns our test values for specific keys,
    # but passes through to the real ENV for other keys
    web_push_vars = {
      'WEB_PUSH_EMAIL' => "test@example.com",
      'WEB_PUSH_PUBLIC_KEY' => "public_key",
      'WEB_PUSH_PRIVATE_KEY' => "private_key"
    }

    allow(ENV).to receive(:[]) do |key|
      web_push_vars[key] || ENV.to_hash[key]
    end
  end

  it 'sends push notifications for each user session' do
    # Expect a call for each session
    expect(WebPush).to receive(:payload_send).twice do |args|
      expect(args).to include(
        message: a_kind_of(String),
        endpoint: a_string_starting_with("http://example.com"),
        p256dh: a_kind_of(String),
        auth: a_kind_of(String),
        vapid: { subject: "mailto:test@example.com", public_key: "public_key", private_key: "private_key" }
      )
      # Validate the JSON message
      message = JSON.parse(args[:message])
      expect(message).to eq({
                              "title" => title,
                              "body" => body,
                              "icon" => icon,
                              "link" => link
                            })
    end

    # Execute the job
    SendNotificationsJob.new.perform(user, title, body, icon, link)
  end
end
