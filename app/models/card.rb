class Card < ApplicationRecord
  belongs_to :company
  validates :number, length: { is: 9 }
end
