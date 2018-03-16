class AddColumnNumberInCard < ActiveRecord::Migration[5.1]
  def change
  	add_column :cards, :number, :string
    add_index :cards, :number, unique: true
  end


end
