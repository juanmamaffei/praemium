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
    @cards = Card.where(company_id: @company)
  end

  # GET /cards/1
  # GET /cards/1.json
  def show
    set_company
    @transaction = Transaction.new
  end

  # GET /cards/new
  def new
    @card = Card.new
  end

  # GET /cards/1/edit
  def edit
  end

  # POST /cards
  # POST /cards.json
  def create
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

  # PATCH/PUT /cards/1
  # PATCH/PUT /cards/1.json
  def update
    
    respond_to do |format|
      if @card.update(card_params)
        format.html { redirect_to @card, notice: 'Card was successfully updated.' }
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
            @error = "El número de cliente de la tarjeta es inválido"
          else
            redirect_to company_card_path(@company,@card)
          end
        else
          @error = "La tarjeta no pertenece a esta compañía"
        end
      else

        #CONSULTAR CLIENTE por QUERY a columnas CLIENT y COMPANY_ID
        @error = "Número inválido"
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
end
