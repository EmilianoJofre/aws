# rubocop:disable Layout/LineLength
class Api::V1::LiabilitiesController < Api::V1::BaseController
  skip_before_action :authenticate_user!
  before_action :authenticate_users!
  skip_before_action :verify_authenticity_token, only: [:create, :edit, :update, :destroy, :pay, :update_money_movement]

  # GET /api/v1/sub_accounts/[sub_account_id]/liabilities
  def index
    if liabilities_memberships
      respond_with liabilities_memberships, investment_asset: true, movements: true, liability: true, root: "liabilities"
    else
      render json: { code: 404, message: "SubAccount doesn't exist" }
    end 
  end

  # POST /api/v1/sub_accounts/[sub_account_id]/liabilities
  def create
    # Valida si el asset_id ingresado pertenece a esa relacion
    if params.has_key?(:asset_id) then
      assets = []
      sub_account.account.relation.relation_accounts.map do |account|
        account.sub_accounts.map do |sub_account|
          assets += sub_account.memberships.map(&:investment_asset_id)
        end
      end

      render(:json => { code: :bad_request, :error => 'El activo (asset_id) no pertenece a este cliente' }, :status => :bad_request) and return if !assets.include?(params[:asset_id])
    end

    ActiveRecord::Base.transaction do
      asset = InvestmentAsset.create!(params_asset_liability.merge(params_asset_liability_permit).merge(currency: sub_account.currency))
      membership = sub_account.memberships.create!(
        create_membership_params.merge(investment_asset_id: asset.id)
      )

      data = params_liability_permit.merge(membership_id: membership.id)
      
      data = data.merge(investment_asset_id: params[:asset_id]) if params.has_key?(:asset_id)
      data = data.merge(investment_asset_id: nil) if !params.has_key?(:asset_id)
      liability = Liability.create!(data)

      # Las deudas se crean de la siguiente forma:
      # - Se crea el membership y la deuda en Liability
      # - Se crea un primer movimiento con: 
      #   - las cuotas restantes
      #   - el valor de la cuota es igual al (saldo insoluto / por cuotas restantes)
      total_fees = params[:total_fees].to_i - params[:fees_paid].to_i
      quota_price = params[:outstanding_balance].to_f / total_fees
      money_movement = membership.money_movements.create!(
        sub_account_id: membership.sub_account_id,
        movement_type: 0,
        average_price: quota_price,
        fee_outstanding_balance: params[:outstanding_balance],
        fee_number: params[:fees_paid],
        quotas: total_fees,
        date: Time.now
      )

      price_change = asset.price_changes.create!(
        value: quota_price,
        price_changed_at: Time.current,
        money_movement_id: money_movement.id
      )

      respond_with membership, investment_asset: true, movements: true, liability: true, root: "liability"
    end
  end

  # PATCH /api/v1/sub_accounts/[sub_account_id]/liabilities/[membership_id]
  def update
    liability = liability_by_membership
    liability.update(params_liability_permit)
    liability.update(investment_asset_id: params[:asset_id]) if params.has_key?(:asset_id)
    respond_with membership_by_id, investment_asset: true, movements: true, liability: true, root: "liability"
  end

  # DELETE /api/v1/sub_accounts/[sub_account_id]/liabilities/[membership_id]
  def destroy
    membership_by_id.update(hidden: true)
    render json: { code: :ok, message: 'Liability deleted' }, status: :ok 
  end

  # GET /api/v1/sub_accounts/[sub_account_id]/liabilities/[membership_id]/money_movements
  def money_movements
    liability = liability_by_membership
    respond_with liability.membership.money_movements
  end

  # PATCH /api/v1/sub_accounts/[sub_account_id]/liabilities/[membership_id]/money_movements/[money_movement_id]
  def update_money_movement
    money_movement = MoneyMovement.find(params[:money_movement_id].to_s)
    
    # Se calcula el nuevo fee_outstanding_balance
    prev_fee_outstanding_balance = money_movement.average_price + money_movement.fee_outstanding_balance
    new_fee_outstanding_balance = prev_fee_outstanding_balance - params[:fee_amount]
    
    money_movement.update(money_movement_params.merge(
      fee_outstanding_balance: new_fee_outstanding_balance,
      fee_number: params[:fee]
    ))

    new_outstanding_balance = membership_by_id.money_movements.purchase.map{|a| a.amount}.sum.round - membership_by_id.money_movements.sale.map{|a| a.amount}.sum.round
    liability = liability_by_membership
    liability.update_columns(outstanding_balance: new_outstanding_balance)
    
    respond_with money_movement
  end

  # POST /api/v1/sub_accounts/[sub_account_id]/liabilities/[membership_id]/pay
  def pay
    ActiveRecord::Base.transaction do
      liability = liability_by_membership

      fee_amount = liability.outstanding_balance - params[:outstanding_balance]
      current_fees_paid = params[:fee] - liability.fees_paid

      liability.fees_paid = params[:fee]
      liability.outstanding_balance = params[:outstanding_balance]
      liability.save

      money_movement = membership_by_id.money_movements.create!(
        sub_account_id: membership_by_id.sub_account_id,
        movement_type: 1,
        average_price: fee_amount.to_f,
        fee_outstanding_balance: params[:outstanding_balance],
        fee_number: params[:fee],
        quotas: 1,
        date: params[:date],
      )
    end

    respond_with membership_by_id, investment_asset: true, movements: true, liability: true, root: "liability"
  end
  
  def enable
    membership.hidden = false
    membership.save
    respond_with membership
  end

  private

  def liabilities_memberships
    sub_account&.memberships&.joins("inner join investment_assets on investment_assets.id = memberships.investment_asset_id")&.where("investment_assets.asset_type in (9)")&.active&.without_custom_asset
  end

  def liability
    Liability.find(params[:id]) if params.has_key?(:id)
  end

  def liability_by_membership
    membership_by_id.liabilities.last
  end

  def params_liability_permit
    params.permit(
      :name,
      :description,
      :initial_debt,
      :debt_participation,
      :total_fees,
      :fees_paid,
      :outstanding_balance,
      :start_date,
      :end_date,
      :payment_cycle,
      :rate,
      :rate_description,
      :rate_type
    )
  end

  def params_asset_liability_permit
    params.permit(
      :name,
    )
  end

  def params_asset_liability
    {
      is_custom: false,
      valid_asset: true,
      asset_type: 9,
      asset_id: params_liability_asset_id
    }
  end

  def params_liability_asset_id
    "liability_#{params[:name].parameterize(separator: '_')}_#{params['sub_account_id']}_#{Time.now.to_i}"
  end

  def sub_account
    demo? ? DemoSubAccount.find_by(id: params['sub_account_id']) : SubAccount.find_by(id: params['sub_account_id'])
  end

  def membership_by_id
    if params.has_key?(:id) then
      return @membership_by_id ||= demo? ? DemoMembership.find(params[:id]) : Membership.find(params[:id])
    end
    if params.has_key?(:liability_id) then
      return @membership_by_id ||= demo? ? DemoMembership.find(params[:id]) : Membership.find(params[:liability_id]) 
    end
  end

  def membership
    @membership ||= demo? ? DemoMembership.find(edit_params['membership_id']) : Membership.find(edit_params['membership_id'])
  end

  def sub_account_id
    params.require(
      :sub_account_id
    )
  end

  def create_membership_params
    params.permit(
      :sub_account_id,
    )
  end

  def edit_params
    params.permit(:membership_id, :hidden)
  end

  def money_movement_params
    mm_params = params.permit(:fee_amount, :date)
    mm_params[:quotas] = 1
    mm_params[:average_price] = params[:fee_amount]
    mm_params.delete(:fee_amount)
    mm_params
  end

  def demo?
    params[:is_demo] == 'true'
  end
end
# rubocop:enable Layout/LineLength
