class CreateHikeCars < ActiveRecord::Migration[7.1]
  def change
    create_table :hike_cars do |t|
      t.references :hike, null: false, foreign_key: true
      t.references :car, null: false, foreign_key: true
      t.jsonb :metadata, default: {}

      t.timestamps
    end
  end
end
