class ClientToOwnersMailer < ApplicationMailer
  default from: 'postmaster@praemium.com.ar'
  
  def new_card_request
  	@user = params[:user]
  	@company = params[:company]
  	owner = User.find(@company.admin)
  	
  	mail(to: owner.email, bcc: "juanmamaffei@gmail.com", subject: "PRAEMIUM: Cliente solicita tarjeta de #{@company.name}")
  	
  end
end
