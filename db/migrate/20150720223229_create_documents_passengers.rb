class CreateDocumentsPassengers < ActiveRecord::Migration
  def change
    create_table :documents_passengers do |t|
      t.integer :trip_id
      t.integer :document_id
      t.integer :passenger_id
      t.boolean :status

      t.timestamps null: false
    end
  end
end
