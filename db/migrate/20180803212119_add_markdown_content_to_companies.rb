class AddMarkdownContentToCompanies < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :markdown_content, :text
    add_column :companies, :content, :text
  end
end
