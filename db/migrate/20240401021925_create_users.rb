# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :uid
      t.string :full_name
      t.string :email, null: false, default: "", index: { unique: true }
      t.string :avatar_url
      t.timestamps null: false
    end
  end
end
