module PermissionsConcern
	extend ActiveSupport::Concern

	def is_client?
		self.permissions <= 10
	end

	#SPRINT2
	def is_employer?
		self.permissions >= 20
	end

	def is_owner?
		self.permissions >= 30

	end

	def is_admin?
		self.permissions >=50
	end
end