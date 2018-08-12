class AddAttachmentLogoToCompanies < ActiveRecord::Migration[5.1]
  def self.up
    change_table :companies do |t|
      t.attachment :logo
      t.attachment :picture
    end
  end

  def self.down
    remove_attachment :companies, :logo
    remove_attachment :companies, :picture
  end
end
