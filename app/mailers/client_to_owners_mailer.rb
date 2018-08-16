class ClientToOwnersMailer < ApplicationMailer
  default from: 'postmaster@praemium.com.ar'
  
  def new_card_request
  	@user = params[:user]
  	@company = params[:company]
  	owner = User.find(@company.admin)
  	#attachments.inline['logo'] = asset_path('logoh')
  	mail(to: owner.email, bcc: "juanmamaffei@gmail.com", subject: "IMPORTANTE! Responder a NUEVO cliente: Nueva petición de TARJETA para #{@company.name}")
  	
  end
end
