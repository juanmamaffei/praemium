class MainController < ApplicationController
	#before_action :authenticate_user!, except(:show)
	layout false

	def index
		set_cards
		set_companies
	end

	def landing
	end
	
	private
		def set_cards
			@cards = Card.where(user: current_user).order(created_at: :desc)
			@company_names = Company.select("name")
		end
		def set_companies
			@companies = Company.where(admin: current_user).order(created_at: :desc)
		end
end
