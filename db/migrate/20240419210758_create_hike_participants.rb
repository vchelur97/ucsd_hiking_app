class CreateHikeParticipants < ActiveRecord::Migration[7.1]
  def change
    create_table :hike_participants do |t|
      t.references :hike_car, null: false, foreign_key: true
      t.integer :position
      t.references :user, null: false, foreign_key: true
      t.jsonb :metadata, default: {}

      t.timestamps
    end
  end
end
