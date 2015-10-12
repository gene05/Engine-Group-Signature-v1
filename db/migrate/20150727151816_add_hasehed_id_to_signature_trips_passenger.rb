class AddHasehedIdToSignatureTripsPassenger < ActiveRecord::Migration
  def change
    add_column :trips_passengers, :hashed_id, :string
  end
end
