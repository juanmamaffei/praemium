class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.references :card, foreign_key: true
      t.references :company, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :amount
      t.string :description

      t.timestamps
    end
  end
end
