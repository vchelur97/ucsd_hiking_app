class AddSubscribersToHikes < ActiveRecord::Migration[7.1]
  def change
    add_column :hikes, :subscribers, :integer, array: true, default: []
  end
end
