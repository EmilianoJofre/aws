class Api::V2::RelationsController < Api::V2::BaseController
  skip_before_action :authenticate_user!
  before_action :authenticate_users!
  respond_to :json

  # POST /api/v2/relations
  def create
    investor = Relation.create!(
      relation_params.merge(password: default_relation_password, user: default_admin_user)
    )

    # Crea una relacion con el asesor si es que se incluye el adviser_id
    show_adviser = false
    if params.has_key?(:adviser_id) then
      AdviserRelation.create!(
        relation: investor,
        adviser_id: params[:adviser_id]
      )
      show_adviser = true
    end

    respond_with investor, root: 'investor', advisers: show_adviser
  end

  # PATCH /api/v2/relations/:id
  def update
    rel = Relation.find(params[:id])
    rel.update!(relation_params)
    respond_with rel, root: 'investor'
  end

  # GET /api/v2/relations/:id
  def show
    render json: { code: 200, message: 'Acceso no autorizado' }, status: :ok and return if filter_by_supervisor

    respond_with Relation.find(params[:id]),
      deep: true,
      real_estate: false,
      advisers: true,
      root: 'investor'
  end

  # DELETE /api/v2/relations/:id
  def destroy
    render json: { code: 200, message: 'Acceso no autorizado' }, status: :ok and return if filter_by_supervisor

    ActiveRecord::Base.transaction do
      Relation.find(params[:id]).update(
        active: false,
        user: default_admin_user
      )

      if !AdviserRelation.find_by_relation_id(params[:id]).nil? then
        AdviserRelation.find_by_relation_id(params[:id]).delete
      end
    end

    render json: {
      code: :ok, message: 'Inversionista eliminado'
    }, status: :ok
  end

  # POST /api/v2/relations/:id/photo
  def upload_photo
    #TODO
    respond_with params
  end

  def balance
    balances = { CLP: 0, USD: 0, EUR: 0, UF: 0 }
    detail = []
    dollar = DollarPrice.step_business_day
    euro = EuroPrice.step_business_day
    uf = UfPrice.step_business_day
    balances[:CLP] += relation.updated_balance
    balances[:USD] += relation.updated_balance / DollarPrice.step_business_day
    balances[:EUR] += relation.updated_balance / EuroPrice.step_business_day
    balances[:UF] += relation.updated_balance / UfPrice.step_business_day
    accounts.each do | account |
      balance = account.balance(Time.now - 1.day)
      account_balance = {name: account.name, balance: { CLP: balance[:CLP], USD: balance[:USD], EUR: balance[:EUR], UF: balance[:UF] }}
      detail.push account_balance
    end
    respond_with balance: balances, detail: detail
  end

  # POST /api/v2/relations/send_email_to_support
  def send_email_to_support
    support_email = params[:support_email]
    investor_name = params[:investor_name]

    if email_sent_successfully?(support_email, investor_name)
      render json: { message: 'Correo enviado correctamente' }, status: :ok
    else
      render json: { message: 'Error al enviar el correo electrónico' }, status: :unprocessable_entity
    end
  end

  def balance_by_type
    balances = { CLP: 0, USD: 0, EUR: 0, UF: 0 }
    detail = []
    relation.relation_accounts.with_type(Account.account_types[params[:account_type].parameterize.underscore.to_sym]).each do | account |
      balance = account.balance(Time.now - 1.day)
      balances[:CLP] += balance[:CLP]
      balances[:USD] += balance[:USD]
      balances[:EUR] += balance[:EUR]
      balances[:UF] += balance[:UF]
      account_balance = {name: account.name, balance: { CLP: balance[:CLP], USD: balance[:USD], EUR: balance[:EUR], UF: balance[:UF] }}
      detail.push account_balance
    end
    respond_with balance: balances, detail: detail
  end

  def get_investments
    # authorize user
    data = Account.where(id: params[:id])
    respond_with data, real_estate: false, deep: true, root: "accounts"
  end

  def get_investments_with_real_estates
    # authorize user
    data = Account.where(id: params[:id])
    respond_with data, real_estate: true, deep: true, root: "accounts"
  end

  private

  def relation
    return Relation.find(params['relation_id'])
  end

  def accounts
    params[:type].nil? ? relation.relation_accounts : relation.relation_accounts.with_type(Account.account_types[params[:type].parameterize.underscore.to_sym])
  end

  def relation_params
    params.permit(
      :first_name,
      :last_name,
      :rut,
      :phone,
      :email,
      :show_wallet,
      modules: [
        :chart_top_distribution_module,
        :chart_country_distribution_module,
        :chart_currency_distribution_module,
        :chart_asset_type_distribution_module,
        :chart_institution_distribution_module,
        :chart_asset_classify_distribution_module,
        :chart_ambiental_vars_distribution_module
      ]
    )
  end

  def default_relation_password
    relation_params[:rut].delete('.')[0..5]
  end

  def filter_by_supervisor
    if !current_supervisor.nil? then
      return true if !supervisor_relations_ids.include?(params[:id].to_i)
    end
    return false
  end

  def supervisor_relations_ids
    relations = []
    current_supervisor.advisers.map do |adviser|
      relations += adviser.relations.map(&:id)
    end
    relations[0]
    # Relation.where(id: relations)
  end

  def demo?
    params[:is_demo] == 'true'
  end

  def email_sent_successfully?(support_email, investor_name)
    SetAdviserMailer.send_adviser_email(support_email, investor_name).deliver_now
    true
  rescue StandardError => e
    Rails.logger.error("Error al enviar el correo electrónico: #{e.message}")
    false
  end
end
