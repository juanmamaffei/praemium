class CreateCards < ActiveRecord::Migration[5.1]
  def change
    create_table :cards do |t|
      t.references :company, foreign_key: true
      t.integer :user
      t.integer :country, default: 779
      t.integer :credit1
      t.integer :credit2
      t.integer :status, default: 0
      t.boolean :credit2_enabled

      t.timestamps
    end
  end
end
