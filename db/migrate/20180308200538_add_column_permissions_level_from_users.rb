class AddColumnPermissionsLevelFromUsers < ActiveRecord::Migration[5.1]
  def change
  	add_column :users, :permissions, :integer, default: 1
  end
end
