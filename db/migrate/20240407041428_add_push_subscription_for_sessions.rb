class AddPushSubscriptionForSessions < ActiveRecord::Migration[7.1]
  def change
    add_column :sessions, :push_endpoint, :string
    add_column :sessions, :push_p256dh, :string
    add_column :sessions, :push_auth, :string
  end
end
