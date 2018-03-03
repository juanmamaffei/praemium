json.extract! client, :id, :clientid, :company_id_id, :cardnumber, :pin, :pin_enabled, :name, :birthdate, :email, :score, :client_enabled, :created_at, :updated_at
json.url client_url(client, format: :json)
