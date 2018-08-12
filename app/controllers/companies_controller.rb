class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:show]
  #Admin sin restricciones
  before_action :authenticate_admin!, only: [:index, :destroy]
  #Dueño de compañía A, SHOW y EDIT compañía A.
  before_action :authenticate_owner!, only: [:edit, :update, :stats]
  #Empleado de compañía A, SHOW de compañía A.
  #Cliente, NADA.

  # GET /companies
  # GET /companies.json
  def index
    @companies = Company.all
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
    @npa = "false"
    if user_signed_in?
      verify_own_id_npa
      @cards = Card.where(company_id: @company.id, user: current_user.id)
    end

    render layout: "companies"
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
    verify_own_id
  end
  def freeTrial

    set_company_id
    if @company.clientcount == 0
      buenas=0
      malas=0
      for i in 1..10
        card = Card.new
        card.company_id = @company.id
        card.credit1 = 0
        card.credit2 = 0
        card.credit2_enabled = true
      # Armar CLIENT(i) y NUMBER (CO,CO,CO,CO,CL,CL,CL,CL,CL)
        card.client = i
        #Llevar CLIENT a 5 caracteres
        cl=i.to_s

        unless cl.length==5
            begin
                cl="0"+cl
            end until cl.length==5
        end

        #Llevar COMPANY a 4 caracteres
        co=@company.id.to_s

        unless co.length==4
            begin
                co="0"+co
            end until co.length==4
        end

        card.number=co+cl
      # Generar PIN aleatorio
        card.pin = rand(1000..9999)

        #Cambiar STATUS según opción elegida

        # Si se guarda, avisar, si no ... también

          if card.save
            buenas=buenas+1
            @company.clientcount=@company.clientcount+1
            @company.save
          else
            malas=malas+1
          end
        end       
        redirect_to company_prueba_path(@company), notice: "Se crearon tus 10 tarjetas de prueba... 
        Tarjetas exitosas: " + buenas.to_s + " | Tarjetas malas: " + malas.to_s + " | Empezando desde el ID: 1 hasta : 10"

    end
    unless @company.alias == "freeTrial"
      redirect_to root_path
    end
  end
  # POST /companies
  # POST /companies.json
  def create
    
    @company = Company.new(company_params)
    #Si el usuario tiene permiso 32, decirle que afloje un toque...
    if current_user.permissions == 32
      redirect_to root_path
    else
    #Si el usuario no es administrador, entonces solicitó una prueba gratuita.
    #forzar los parámetros estándar de la prueba gratuita
    unless current_user.is_admin?
      @company.admin = current_user.id
      @company.clientcount = 0
      @company.alias = "freeTrial"
      #Bloquear la creación de empresas (para que no cree 2 millones...)
      #usando el permiso 32
      if current_user.permissions < 30
        current_user.permissions = 32
        current_user.save
      end
    end
    
    

      respond_to do |format|
        if @company.save
          format.html { redirect_to company_prueba_path(@company) }
          format.json { render :show, status: :created, location: @company }
        else
          format.html { render :new }
          format.json { render json: @company.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to @company, notice: 'Se actualizaron los datos correctamente.' }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company.destroy
    respond_to do |format|
      format.html { redirect_to companies_url, notice: 'Company was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def stats
    set_company_id
    verify_own_id

    #Consultar a la base de datos
    @allTransactions = Transaction.where('company_id' => @company.id)
    @allCards = Card.where('company_id' => @company.id)

    @counter = Array.new
    #Contar transacciones realizadas
    @counter[1] = @allTransactions.count
    
    #Contar tarjetas totales
    @counter[2] = @allCards.count

    #Contar tarjetas activas
    @counter[3] = @allCards.where('status'=> 1).count

    #Tarjetas inactivas
    @counter[4] = @allCards.where('status'=> 0).count

    #Tarjetas robadas
    @counter[5] = @allCards.where('status'=> 2).count

    #Tarjetas registradas
    @counter[6] = @allCards.where.not('user'=>nil).count

    #Tarjetas NO registradas
    @counter[7] = @allCards.where('user'=>nil).count

    #Iterar transactions
      #Total de saldo ingresado
      
      #Total de saldo consumido

      #Total de puntos ingresados

      #Total de puntos consumidos

    #Iterar CARDS
      #find Cliente. Guardarlo en array.

        #Sumar credit1

        #Sumar credit2
      #Si no es cliente registrado, guardarlo en otro array.
        
        #Sumar credit1

        #Sumar credit2
    
  end

  def send_mail_card_request
    set_company_id
    ClientToOwnersMailer.with(user: current_user, company: @company).new_card_request.deliver_now
    
    redirect_to company_path(@company.id, notice: "Listo! Ya enviamos tus datos al administrador de #{@company.name}, para que cree tu tarjeta. Se pondrá en contacto con vos a la brevedad.")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end
    def set_company_id
      @company = Company.find(params[:company_id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.require(:company).permit(:name, :url, :admin, :clientcount, :employers, :alias, :cover, :markdown_content, :facebook, :website, :twitter, :email, :instagram, :linkedin, :whatsapp, :phone, :store_enabled, :picture, :logo, :about_us_enabled, :other_info_enabled, :about_us, :other_info)
    end

    def verify_own_id_npa
      unless (@company.admin == current_user.id) or current_user.is_admin?

           @npa = "true"
    
      end

    end
    def verify_own_id
      unless (@company.admin == current_user.id) or current_user.is_admin?

           redirect_to root_path
    
      end

    end
end
