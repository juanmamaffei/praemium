class CreateClients < ActiveRecord::Migration[5.1]
  def change
    create_table :clients do |t|
      t.integer :clientid
      t.references :company_id, foreign_key: true
      t.integer :cardnumber
      t.integer :pin
      t.boolean :pin_enabled
      t.string :name
      t.date :birthdate
      t.string :email
      t.integer :score
      t.integer :client_enabled

      t.timestamps
    end
  end
end
