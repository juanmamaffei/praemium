class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:show]
  #Admin sin restricciones
  before_action :authenticate_admin!, only: [:index, :destroy]
  #Dueño de compañía A, SHOW y EDIT compañía A.
  before_action :authenticate_owner!, only: [:edit, :update]
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
    if user_signed_in?
      verify_own_id
    end
    @cards = Card.where(company_id: @company)
    
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
      params.require(:company).permit(:name, :url, :admin, :clientcount, :employers, :alias, :cover)
    end

    def verify_own_id
      unless (@company.admin == current_user.id)
        unless current_user.is_admin?
           @nopuedeadministrar = true
        end
      end
    end
end
