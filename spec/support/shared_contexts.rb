require 'webmock/rspec'

def set_google_omniauth(user_attrs = attributes_for(:user))
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
                                                                       provider: 'google_oauth2',
                                                                       uid: '123456',
                                                                       info: {
                                                                         email: user_attrs[:email],
                                                                         first_name: user_attrs[:full_name].split.first,
                                                                         last_name: user_attrs[:full_name].split.last,
                                                                         image: user_attrs[:avatar_url]
                                                                       },
                                                                       credentials: {
                                                                         token: "abc123",
                                                                         refresh_token: "def456"
                                                                       }
                                                                     })
end

def user_login(user = create(:user, :with_details, :with_signed_waiver, :hiker))
  set_google_omniauth(user)
  visit new_user_session_path
  click_button "Sign in with Google"
  wait_for_turbo
  @user = user
end

def user_logout
  click_link "Log out"
end
