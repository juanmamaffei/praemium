class CardsController < ApplicationController
  before_action :set_card, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:show]
  #Admin sin restricciones
  before_action :authenticate_admin!, only: [:destroy]
  #Dueño de compañía A, NEW y CREATE
  before_action :authenticate_owner!, only: [:index, :new, :create, :edit, :update, :scan]
  #Empleado de compañía A, SHOW, INDEX y EDIT de compañía A.
  #Cliente, SHOW, pidiendo el PIN si el USUARIO es NIL. Si no, autenticar y SHOW sólo de sus tarjetas asociadas.


  # GET /cards
  # GET /cards.json
  def index
    set_company
    verify_own_id
    
    #Orden por defecto
    filtro = 'client'
    # Ordenamiento
    if(params[:order]=="asc")
      if(params[:field]=="name")
        filtro = 'user'
      end
      if(params[:field]=="cardNumber")
        filtro = 'number'
      end
      if(params[:field]=="amount")
        filtro = 'credit1'
      end
      if(params[:field]=="score")
        filtro = 'credit2'
      end  
          
    end
    if(params[:order]=="desc")
      if(params[:field]=="name")
        filtro = 'user DESC'
      end
      if(params[:field]=="cardNumber")
        filtro = 'number DESC'
      end
      if(params[:field]=="amount")
        filtro = 'credit1 DESC'
      end
      if(params[:field]=="score")
        filtro = 'credit2 DESC'
      end  
            
    end
    
    
    if(params[:soloactivas])
        @cards = Card.where(company_id: @company, status: "1").order(filtro).paginate(:page => params[:page], :per_page => 20)
        message = filtro
    else
        @cards = Card.where(company_id: @company).order(filtro).paginate(:page => params[:page], :per_page => 20)
        message = filtro
    end


    @users = User.all

    #Requires para generar códigos de barra
    require 'barby'
    require 'barby/barcode/ean_13'
    require 'barby/outputter/png_outputter'
    
    #Exportar a xlsx

    respond_to do |format|
      format.html
      #format.csv { send_data @cards.to_csv }
      format.xlsx { render xlsx: "index.xlsx"}
    end
  end

  def asignuser
    
    #Tomar params num y pin
    num = params[:num]
    pin = params[:pin]
    num.to_s
    #Verificar cantidad de dígitos
    if num.length==13
      if pin.to_s.length==4
        #Descomponer el número de tarjeta
        country=num[0..2].to_i
        number=num[3..11]
        #Consultar BD buscando la tarjeta
        card=Card.find_by(country: country, number: number)
        #Si no hay resultados, devolver error
        unless card==nil
          #Si hay resultado, verificar que la tarjeta no tenga otro usuario asignado
          if card.user==nil
            #Si todo lo anterior está bien, verificar que el pin sea el correcto
            pin.to_i
            if pin.to_s == card.pin.to_s
              card.user= current_user.id
              if card.save
                redirect_to root_path, notice: "Asignaste usuario a tu nueva tarjeta"
              else
                redirect_to root_path, notice: "**Tus datos son correctos pero ocurrió un error. Contactá con el administrador"
              end
            else
              redirect_to root_path, notice: "**Pin incorrecto"
            end


          else
            #Esta tarjeta tiene otro usuario asignado
            redirect_to root_path, notice: "**Esta tarjeta ya tiene un usuario asignado"
          end
          
        else
          #No existe esa tarjeta
          redirect_to root_path, notice: "**No existe esa tarjeta."
        end
        
      else
        #Pin inválido
        redirect_to root_path, notice: "**Pin inválido"
      end
    else
      #Num inválido
      redirect_to root_path, notice: "**Número de tarjeta inválido"
    end
    

  end

  # GET /cards/1
  # GET /cards/1.json
  def show
    set_company
    unless @company.id == @card.company_id
      redirect_to root_path, notice: "**COMPAÑÍA INVÁLIDA"
      
    end
    @transaction = Transaction.new
    unless @card.user == nil
      @usuario = User.find(@card.user)
    end

  end

  # GET /cards/new
  def new
    set_company
    @card = Card.new
  end

  # GET /cards/1/edit
  def edit
  end

  # POST /cards
  # POST /cards.json
  def createlik
    @card = Card.new(card_params)

    respond_to do |format|
      if @card.save
        format.html { redirect_to @card, notice: 'Card was successfully created.' }
        format.json { render :show, status: :created, location: @card }
      else
        format.html { render :new }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
#QUITAR ESTO CUANDO SE AUTOMATICE LA TAREA DE CRACIÓN DE TARJETAS
    unless current_user.is_admin?

      redirect_to root_path, notice: "**Por el momento no estás autorizado a realizar esta tarea."
    else


    # Variables del hash: "cant",  "type" ("tabla","impresion" o "encargo"), "commit"=>"Crear", "company_id"
    set_company
    create_params
    

    # Validar cantidad
    unless @cant<0 || @cant>1000
      # Repetir cantidad desde CLIENTCOUNT+1 hasta CLIENTCOUNT+1+CANT
      inicio=@company.clientcount+1
      fin=inicio+@cant-1
        buenas=0
        malas=0
      for i in inicio..fin
        card = Card.new
        card.company_id = @company.id
        card.credit1 = 0
        card.credit2 = 0
        card.credit2_enabled = false
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
        redirect_to company_cards_path, notice: "Se terminó el proceso... 
        Tarjetas exitosas: " + buenas.to_s + " | Tarjetas malas: " + malas.to_s + " | Empezando desde el ID: " + inicio.to_s + " hasta : " + fin.to_s

    end

  end
  end

  # PATCH/PUT /cards/1
  # PATCH/PUT /cards/1.json
  def update
    set_company
    respond_to do |format|
      if @card.update(card_params)
        format.html { redirect_to company_card_path(@company,@card), notice: 'Tarjeta actualizada' }
        format.json { render :show, status: :ok, location: @card }
      else
        format.html { render :edit }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cards/1
  # DELETE /cards/1.json
  def destroy
    @card.destroy
    respond_to do |format|
      format.html { redirect_to company_cards_url, notice: 'Card was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def scan
    set_company
    query_present

    mobile_param

    if @q.present?
      #Paso 2: Consultar tarjeta
      @paso=2
      @q.to_s

      if @q.length==13

        card_number=@q[3,9] 
        card_company= card_number[0,4].to_i

        #CONSULTAR CLIENTE por QUERY a columna NUMBER
        if card_company == @company.id
          @card = Card.find_by number: card_number
          if @card == nil
            @error = "**El número de cliente de la tarjeta es inválido"
          else
            redirect_to company_card_path(@company,@card)
          end
        else
          @error = "**La tarjeta no pertenece a esta compañía"
        end
      else
        
        if @q.length<5
          #Llevar company.id a 4 dígitos
          co=@company.id.to_s
          unless co.length==4
              begin
                  co="0"+co
              end until co.length==4
          end

          

          #Llevar CLIENT a 5 caracteres
          cl=@q.to_s

          unless cl.length==5
              begin
                  cl="0"+cl
              end until cl.length==5
          end

          card_number=co+cl;

          @card = Card.find_by number: card_number
            if @card == nil
              @error = "**El número de cliente de la tarjeta es inválido"
            else
              redirect_to company_card_path(@company,@card)
            end
        else       
          @error = "**Número inválido"
        end
      end

    else

        #Paso 1: Definir tarjeta de la cual se quiere debitar o acreditar
        @paso=1

    end


  end

  def movimiento
    set_card
    set_company
    credit=params[:credit].to_i
    debit=params[:debit].to_i

    nuevocred=@card.credit1+cred-deb
    @card.credit1=nuevocred
    @card.Save
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_card
      @card = Card.find(params[:id])
    end
    def create_params
      @cant = params["cant"].to_i
      type = params[:type]
    end
    def asign_params
      num = params[:num]
      pin = params[:pin]
    end
    def set_company
      @company = Company.find(params[:company_id])      
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def card_params
      params.require(:card).permit(:user, :country, :credit1, :credit2, :status, :credit2_enabled, :client)
    end
        def verify_own_id
      unless (@company.admin == current_user.id)
        unless current_user.is_admin?
           redirect_to root_path
        end
      end
    end
    def query_present
      @q=params[:q]
    end
    def mobile_param
      if params[:mobile].to_s == 'true'
        @mobile = true
      else
        @mobile = false
      end
    end
end
