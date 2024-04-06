class AddProfileToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :phone_no, :string
    add_column :users, :discord, :string
    add_column :users, :preferred_name, :string

    create_table :waivers do |t|
      t.references :user, null: false, foreign_key: true
      t.string :ip_address, null: false
      t.string :user_agent, null: false
      t.integer :version, null: false

      t.index %i[user_id version], unique: true

      t.timestamps
    end
  end
end
