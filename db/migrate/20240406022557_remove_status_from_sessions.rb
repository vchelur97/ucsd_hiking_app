class RemoveStatusFromSessions < ActiveRecord::Migration[7.1]
  def change
    remove_column :sessions, :status, :string
  end
end
