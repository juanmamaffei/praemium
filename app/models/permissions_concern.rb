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
	#Permiso 32: es dueño pero no puede crear empresas.
	# => Se le asigna automáticamente a los registrados que crean una empresa de prueba.
	# => Se puede asignar manualmente a otros dueños para que no creen empresas.
	# => No se le asignará automáticamente a aquellos que creen una empresa con permiso mayor o igual a 30.

	def is_admin?
		self.permissions >=50
	end
end