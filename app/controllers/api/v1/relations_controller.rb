# rubocop:disable Layout/LineLength
class Api::V1::RelationsController < Api::V1::BaseController
  skip_before_action :verify_authenticity_token, if: :json_request?
  skip_before_action :authenticate_user!
  before_action :authenticate_users!

  def index
    data = demo? ? DemoRelation.order(:id) : Relation.order(:id)
    respond_with data, root: "relations"
  end

  def balance
    balances = { CLP: 0, USD: 0, EUR: 0, UF: 0, MXN: 0, COP: 0, CRC: 0 }
    dollar = DollarPrice.step_business_day
    euro = EuroPrice.step_business_day
    uf = UfPrice.step_business_day
    mxn = MxnPrice.step_business_day
    cop = CopPrice.step_business_day
    crc = CrcPrice.step_business_day

    balances[:CLP] += relation.updated_balance
    balances[:USD] += relation.updated_balance / DollarPrice.step_business_day
    balances[:EUR] += relation.updated_balance / EuroPrice.step_business_day
    balances[:UF] += relation.updated_balance / UfPrice.step_business_day
    balances[:MXN] += relation.updated_balance / MxnPrice.step_business_day
    balances[:COP] += relation.updated_balance / CopPrice.step_business_day
    balances[:CRC] += relation.updated_balance / CrcPrice.step_business_day
    respond_with balances
  end

  def create
    respond_with current_user.relations.create!(
      relation_params.merge(password: default_relation_password)
    )
  end

  def update
    relation_to_edit.update!(relation_params)
    respond_with relation_to_edit
  end

  def destroy
    respond_with relation_to_edit.destroy!
  end

  def get_history_balances
    # authorize user
    respond_with RelationBalancesForDates.for(
      from: from_date,
      to: current_date,
      step: step,
      relation: relation
    ).to_json
  end

  def wallet_balances
    respond_with WalletBalancesForDates.for(
      from: from_date,
      to: current_date,
      step: step,
      relation: relation
    ).to_json
  end

  def chart_history
    respond_with SelectedAccountsBalanceJob.perform_now(relation, params[:ids], params[:window], params[:type_filter])
  end

  def get_investments
    # authorize user
    data = demo? ? relation.demo_relation_accounts.where(id: params[:id]) : relation.relation_accounts.where(id: params[:id])
    respond_with data, real_estate: false, deep: true, root: "accounts"
  end
  
  def get_investments_with_real_estates
    # authorize user
    data = demo? ? relation.demo_relation_accounts.where(id: params[:id]) : relation.relation_accounts.where(id: params[:id])
    respond_with data, real_estate: true, deep: true, root: "accounts"
  end

  def get_investments_with_liabilities
    # authorize user
    data = demo? ? relation.demo_relation_accounts.where(id: params[:id]) : relation.relation_accounts.where(id: params[:id])
    respond_with data, liability: true, deep: true, root: "accounts"
  end

  def get_investments_with_others
    # authorize user
    data = demo? ? relation.demo_relation_accounts.where(id: params[:id]) : relation.relation_accounts.where(id: params[:id])
    respond_with data, others: true, deep: true, root: "accounts"
  end

  def get_investments_with_insurances
    data = relation.relation_accounts.where(id: params[:id])
    respond_with data, insurances: true, deep: true, root: "accounts"
  end

  def queue_chart_update
    UpdateRelationChartsJob.perform_later(relation)
  end

  def get_assets
    assets = []
    relation.relation_accounts.map do |account|
      account.sub_accounts.map do |sub_account|
        assets += sub_account.memberships.map(&:investment_asset_id) 
      end
    end
    
    if params.include?('hide_liabilities') and params[:hide_liabilities] == 'true' then
      respond_with InvestmentAsset.where(id: assets).where.not(asset_type: 'liability'), root: 'assets'
    else
      respond_with InvestmentAsset.where(id: assets), root: 'assets'
    end
  end

  private

  def user
    current_user || current_relation
  end

  def relation
    demo? ? DemoRelation.find(params['relation_id']) : Relation.find(params['relation_id'])
  end

  def relation_to_edit
    @relation_to_edit ||= Relation.find(params[:id])
  end

  def get_relation
    @relation ||= Relation.find(params[:id])
  end

  def relation_params
    params.permit(
      :first_name,
      :last_name,
      :rut,
      :phone,
      :email,
      :show_wallet,
      :modules
    )
  end

  def demo?
    params[:is_demo] == 'true'
  end

  def default_relation_password
    relation_params[:rut].delete('.')[0..5]
  end

  def history_balances_params
    params.permit(:from)
  end

  def from_date
    from = history_balances_params[:from]
    @from_date ||= from == 'ORIGIN' ? relation.created_at.to_date : Time.zone.parse(from).to_date
  end

  def step
    (current_date - from_date) / 30
  end

  def current_date
    @current_date ||= Time.current.to_date
  end
end
# rubocop:enable Layout/LineLength
