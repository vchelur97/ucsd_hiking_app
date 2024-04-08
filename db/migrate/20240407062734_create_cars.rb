class CreateCars < ActiveRecord::Migration[7.1]
  def change
    create_table :cars do |t|
      t.references :user, null: false, foreign_key: true
      t.string :make
      t.string :model
      t.string :color
      t.integer :capacity
      t.string :license_plate
      t.float :mpg

      t.timestamps
    end
  end
end
