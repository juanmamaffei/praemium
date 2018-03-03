class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.references :company_id, foreign_key: true
      t.references :client_id, foreign_key: true
      t.integer :score

      t.timestamps
    end
  end
end
