class Company < ApplicationRecord
	has_attached_file :cover, styles: { large: "1280x720>" , medium: "300x150", thumb: "100x100>" }, default_url: "/images/:style/missing_cover.jpg"
	validates_attachment_content_type :cover, content_type: /\Aimage\/.*\z/
	has_many :cards

	has_attached_file :logo, styles: { large: "1280x720>" , medium: "300x150", thumb: "100x100>" }, default_url: "/images/:style/missing_logo.jpg"
	validates_attachment_content_type :logo, content_type: /\Aimage\/.*\z/

	has_attached_file :picture, styles: { large: "1280x720>" , medium: "300x150", thumb: "100x100>" }, default_url: "/images/:style/missing_picture.jpg"
	validates_attachment_content_type :picture, content_type: /\Aimage\/.*\z/
end
