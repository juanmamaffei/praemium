class AddFieldsToCompanies < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :facebook, :string
    add_column :companies, :twitter, :string
    add_column :companies, :website, :string
    add_column :companies, :email, :string
    add_column :companies, :instagram, :string
    add_column :companies, :linkedin, :string
    add_column :companies, :phone, :string
    add_column :companies, :whatsapp, :string
    add_column :companies, :about_us, :text
    add_column :companies, :about_us_enabled, :boolean
    add_column :companies, :other_info, :text
    add_column :companies, :other_info_enabled, :boolean
    add_column :companies, :template, :integer
    add_column :companies, :store_enabled, :boolean
  end
end
