class Transaction < ApplicationRecord
  belongs_to :card
  belongs_to :company
  belongs_to :user
end
