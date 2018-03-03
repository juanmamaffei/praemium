class Transaction < ApplicationRecord
  belongs_to :company_id
  belongs_to :client_id
end
