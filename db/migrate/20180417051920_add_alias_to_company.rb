class AddAliasToCompany < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :alias, :string, uniqueness: true
  end
end
