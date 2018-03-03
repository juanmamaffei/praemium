class CreateCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :url
      t.integer :admin
      t.integer :clientcount
      t.string :employers

      t.timestamps
    end
  end
end
