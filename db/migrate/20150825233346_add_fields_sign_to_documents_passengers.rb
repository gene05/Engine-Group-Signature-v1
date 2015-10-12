class AddFieldsSignToDocumentsPassengers < ActiveRecord::Migration
  def change
    add_column :documents_passengers, :typed_id, :integer
    add_column :documents_passengers, :signed_name, :string
    add_column :documents_passengers, :signed_date, :date
  end
end
