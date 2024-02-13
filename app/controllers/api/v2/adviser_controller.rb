class Api::V2::AdviserController < Api::V2::BaseController
  skip_before_action :authenticate_user!
  before_action :authenticate_users!
  respond_to :json
  
  # GET /api/v2/adviser
  def index
    # TODO: Crer una respuesta global que funcione
    if current_adviser.nil? then
      render json: { code: 200, message: 'Acceso no autorizado' }, status: :ok
      return
    end
    respond_with ActiveModelSerializers::SerializableResource.new(current_adviser, each_serializer: Api::V2::AdviserSerializer)
  end

  # GET /api/v2/adviser/resume
  def resume
    # TODO: Crer una respuesta global que funcione
    if current_adviser.nil? then
      render json: { code: 200, message: 'Acceso no autorizado' }, status: :ok
      return
    end
    
    response = {
      investor_quantity: 0,
      accounts_quantity: 0,
      total_balance: { CLP: 0, USD: 0, EUR: 0, UF: 0, MXN:0, COP: 0, CRC: 0, total: 0 }
    }

    response[:investor_quantity] = current_adviser.relations.count
  
    current_adviser.relations.map do |relation|
      response[:accounts_quantity] += relation.relation_accounts.count
      response[:total_balance][:total] += relation.updated_balance
      response[:total_balance][:CLP] += relation.updated_balance
      response[:total_balance][:USD] += relation.updated_balance / DollarPrice.step_business_day
      response[:total_balance][:EUR] += relation.updated_balance / EuroPrice.step_business_day
      response[:total_balance][:UF] += relation.updated_balance / UfPrice.step_business_day
      response[:total_balance][:MXN] += relation.updated_balance / MxnPrice.step_business_day
      response[:total_balance][:COP] += relation.updated_balance / CopPrice.step_business_day
      response[:total_balance][:CRC] += relation.updated_balance / CrcPrice.step_business_day
    end

    render json: response.to_json, status: :ok
  end

  # GET /api/v2/adviser/investors
  def investors
    # TODO: Crer una respuesta global que funcione
    if current_adviser.nil? then
      render json: { code: 200, message: 'Acceso no autorizado' }, status: :ok
      return
    end
    
    respond_with current_adviser.relations, 
      simplified: true, 
      root: 'investors'
  end

  # GET /api/v2/adviser/investors_complex
  def investors_complex
    # TODO: Crer una respuesta global que funcione
    if current_adviser.nil? then
      render json: { code: 200, message: 'Acceso no autorizado' }, status: :ok
      return
    end
    
    respond_with current_adviser.relations, 
      deep: true, 
      real_estate: false,
      root: 'investors'
  end
end
