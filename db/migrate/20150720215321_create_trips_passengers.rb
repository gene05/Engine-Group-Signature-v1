class CreateTripsPassengers < ActiveRecord::Migration
  def change
    create_table :trips_passengers do |t|
      t.integer :trip_id
      t.integer :passenger_id

      t.timestamps null: false
    end
  end
end
