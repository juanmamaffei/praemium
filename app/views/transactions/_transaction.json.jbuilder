json.extract! transaction, :id, :card_id, :company_id, :user_id, :amount, :description, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
