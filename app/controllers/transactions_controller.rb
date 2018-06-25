class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]
  before_action :set_company_card
  before_action :authenticate_admin!, only: [:destroy]
  before_action :authenticate_owner!, only: [:new, :create, :edit, :update]

  # GET /transactions
  # GET /transactions.json
  def index

    #Sólo se puede ver si está logueado como OWNER del company_id asociado a la CARD
    # o como USUARIO asociado a la tarjeta.
    unless current_user.id==@card.user
      unless (@company.admin == current_user.id)
        unless current_user.is_admin?
           redirect_to root_path, notice: "No estás autorizado a ver las transacciones de esta tarjeta."
        end
      end
    end

    @transactions = Transaction.where(card: @card, company: @company).order("created_at DESC")
    
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
  end

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions
  # POST /transactions.json
  def create
    set_company_card
    @transaction = Transaction.new(transaction_params)
    
    @transaction.company = @company
    @transaction.card = @card
    @transaction.user = current_user
    
    @card.credit1 = @card.credit1.to_i+transaction_params[:amount].to_i

    if @card.save
      respond_to do |format|
        if @transaction.save
          format.html { redirect_to company_panel_path(@company), notice: '*T* Se generó la transacción correctamente. <h2 class="red-text center">El cliente tiene ahora un saldo de <span class="grantexto"><br><br><br>$' + ((@card.credit1.to_f)/100).to_s + '</span></h2><br>' }
          format.json { render :show, status: :created, location: @transaction }
        else
          format.html { render :new }
          format.json { render json: @transaction.errors, status: :unprocessable_entity }
        end
      end
    else
      format.html { render :new  }
      format.json { render json: @card.errors, status: :unprocessable_entity }
    end
  end

  # PATCH/PUT /transactions/1
  # PATCH/PUT /transactions/1.json
  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to @transaction, notice: 'Transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.json
  def destroy
    @transaction.destroy
    respond_to do |format|
      format.html { redirect_to transactions_url, notice: 'Transaction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transaction_params
      params.require(:transaction).permit(:card_id, :company_id, :user_id, :amount, :description)
    end

    def set_company_card
      @company = Company.find(params[:company_id]) 
      @card = Card.find(params[:card_id]) 
    end

    def verify_own_id
      unless (@company.admin == current_user.id)
        unless current_user.is_admin?
           redirect_to root_path, notice: "No estás autorizado a ver esto."
        end
      end
    end
end
