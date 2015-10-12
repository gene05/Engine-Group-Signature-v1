class AddSignatureToDocumentsPassenger < ActiveRecord::Migration
  def change
    add_column :documents_passengers, :signature, :string
  end
end
