class SendNotificationsJob < ApplicationJob
  queue_as :default

  def perform(user, title, body, icon, link)
    send_push_notification(user, title, body, icon, link)
  end

  private

  def build_vapid_details
    {
      subject: "mailto:#{ENV['WEB_PUSH_EMAIL']}",
      public_key: ENV['WEB_PUSH_PUBLIC_KEY'],
      private_key: ENV['WEB_PUSH_PRIVATE_KEY']
    }
  end

  def build_push_message(title, body, icon, link)
    {
      title:,
      body:,
      icon:,
      link:
    }
  end

  def send_push_notification(user, title, body, icon, link)
    user.sessions.each do |session|
      WebPush.payload_send(
        message: JSON.generate(build_push_message(title, body, icon, link)),
        endpoint: session.push_endpoint,
        p256dh: session.push_p256dh,
        auth: session.push_auth,
        vapid: build_vapid_details
      )
    end
  end
end
