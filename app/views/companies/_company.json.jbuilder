json.extract! company, :id, :name, :url, :admin, :clientcount, :employers, :created_at, :updated_at
json.url company_url(company, format: :json)
