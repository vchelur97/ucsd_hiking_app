class CreateHikes < ActiveRecord::Migration[7.1]
  def change
    create_table :hikes do |t|
      t.string :title
      t.string :description
      t.date :date
      t.time :time
      t.references :host, foreign_key: { to_table: :users }
      t.float :length
      t.integer :elevation
      t.string :route_type
      t.integer :duration
      t.string :trailhead_address
      t.string :alltrails_link
      t.string :suggested_items
      t.string :driver_compensation_type
      t.string :notes
      t.string :status
      t.jsonb :metadata

      t.timestamps
    end
  end
end
