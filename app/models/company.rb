class Company < ApplicationRecord
	has_attached_file :cover, styles: { large: "1280x720>" , medium: "300x150", thumb: "100x100>" }, default_url: "/images/:style/missing_cover.jpg"
	validates_attachment_content_type :cover, content_type: /\Aimage\/.*\z/
	has_many :cards
end
