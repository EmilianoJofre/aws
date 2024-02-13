class Api::V2::SupervisorController < Api::V2::BaseController
  skip_before_action :authenticate_user!
  before_action :authenticate_users!
  respond_to :json

  # GET /api/v2/supervisor
  def get_current
    # TODO: Crer una respuesta global que funcione
    if current_supervisor.nil? then
      render json: { code: 200, message: 'Acceso no autorizado' }, status: :ok
      return
    end
    respond_with current_supervisor
  end

  # GET /api/v2/supervisor/all/:supervisor_id
  def get_supervisor
    supervisor = Supervisor.find_by(id: params[:supervisor_id])
    if supervisor
      respond_with supervisor, resume: true
    else
      render json: { message: "Supervisor with ID #{params[:supervisor_id]} not found" }
    end
  end

  # GET /api/v2/supervisor/all/:supervisor_id/advisers
  def get_supervisor_advisers
    supervisor = Supervisor.find_by(id: params[:supervisor_id])
    if supervisor
      respond_with paginate(supervisor.advisers.order(first_name: :asc, last_name: :asc)), resume: true
    else
      render json: { message: "Supervisor with ID #{params[:supervisor_id]} not found" }
    end
  end


  # GET /api/v2/supervisor/all
  def get_all
    # TODO: Crer una respuesta global que funcione
    if current_supervisor.nil? then
      render json: { code: 200, message: 'Acceso no autorizado' }, status: :ok
      return
    end
    respond_with paginate(supervisors.order(:id)), resume: true
  end

  # GET /api/v2/supervisor/resume
  def resume
    # TODO: Crer una respuesta global que funcione
    if current_supervisor.nil? then
      render json: { code: 200, message: 'Acceso no autorizado' }, status: :ok
      return
    end

    response = {
      supervisor_quantity: 0,
      adviser_quantity: 0,
      investor_quantity: 0,
      total_balance: { CLP: 0, USD: 0, EUR: 0, UF: 0,MXN: 0,CRC: 0, COP: 0, total: 0 }
    }

    response[:supervisor_quantity] = Supervisor.where(vendor_id: current_supervisor.vendor_id).count
    response[:adviser_quantity] = current_supervisor.advisers.count
    response[:investor_quantity] = relations.count

    relations.map do |relation|
      response[:total_balance][:total] += relation.updated_balance
      response[:total_balance][:CLP] += relation.updated_balance
      response[:total_balance][:USD] += relation.updated_balance / DollarPrice.step_business_day
      response[:total_balance][:EUR] += relation.updated_balance / EuroPrice.step_business_day
      response[:total_balance][:UF] += relation.updated_balance / UfPrice.step_business_day
      response[:total_balance][:MXN] += relation.updated_balance / MxnPrice.step_business_day
    end

    render json: response.to_json, status: :ok
  end

  # POST /api/v2/supervisor
  def create
    # TODO: Crer una respuesta global que funcione
    if current_supervisor.nil? then
      render json: { code: 200, message: 'Acceso no autorizado' }, status: :ok
      return
    end

    sup = Supervisor.create!(user_params.merge(vendor_id: current_supervisor.vendor_id, password: params[:password]))
    respond_with sup, root: 'supervisor'
  end

  # PATCH /api/v2/supervisor
  def update
    # TODO: Crer una respuesta global que funcione
    if current_supervisor.nil? then
      render json: { code: 200, message: 'Acceso no autorizado' }, status: :ok
      return
    end

    sup = Supervisor.find(current_supervisor.id)
    sup.update!(user_params)
    respond_with sup, root: 'supervisor'
  end

    # PATCH /api/v2/supervisor/:supervisor_id
  def update_supervisor
    # TODO: Crer una respuesta global que funcione
    if current_supervisor.nil? then
      render json: { code: 200, message: 'Acceso no autorizado' }, status: :ok
      return
    end

    sup = Supervisor.find_by(id: params[:supervisor_id])
    if sup.nil?
      render json: { code: 200, message: 'Supervisor no encontrado' }, status: :ok
      return
    end

    sup.update!(user_params)
    respond_with sup, root: 'supervisor'
  end

  # ADVISERS

  # GET /api/v2/supervisor/advisers
  def get_advisers
    # TODO: Crer una respuesta global que funcione
    if current_supervisor.nil? then
      render json: { code: 200, message: 'Acceso no autorizado' }, status: :ok
      return
    end

    respond_with paginate(advisers.order(first_name: :asc, last_name: :asc)), resume: true
  end

  # GET /api/v2/supervisor/advisers/:adviser_id
  def show_adviser
    # TODO: Crer una respuesta global que funcione
    if current_supervisor.nil? then
      render json: { code: 200, message: 'Acceso no autorizado' }, status: :ok
      return
    end

    respond_with advisers.where(id: params[:adviser_id])
  end

  # GET /api/v2/supervisor/advisers/:adviser_id/resume
  def adviser_resume
    # TODO: Crer una respuesta global que funcione
    if current_supervisor.nil?
      render json: { code: 200, message: 'Acceso no autorizado' }, status: :ok
      return
    end

    adviser = Adviser.find_by(id: params[:adviser_id])
    if adviser
      response = {
        adviser_id: adviser.id,
        investor_quantity: 0,
        accounts_quantity: 0,
        total_balance: { CLP: 0, USD: 0, EUR: 0, UF: 0, MXN: 0, COP: 0, CRC: 0, total: 0 }
      }

      response[:investor_quantity] = adviser.relations.count

      adviser.relations.each do |relation|
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
    else
      render json: { message: "Adviser with ID #{params[:adviser_id]} not found" }
    end
  end

  # POST /api/v2/supervisor/advisers
  def create_adviser
    # TODO: Crer una respuesta global que funcione
    if current_supervisor.nil? then
      render json: { code: 200, message: 'Acceso no autorizado' }, status: :ok
      return
    end

    adviser = Adviser.create!(
      user_params.merge(password: default_user_password)
    )

    # Crea una relacion con el Supervisor que creo al asesor
    SupervisorAdviser.create!(
      adviser: adviser,
      supervisor_id: current_supervisor.id
    )

    respond_with adviser, root: 'adviser'
  end

  # PATCH /api/v2/supervisor/advisers/:adviser_id
  def update_adviser
    # TODO: Crer una respuesta global que funcione
    if current_supervisor.nil? then
      render json: { code: 200, message: 'Acceso no autorizado' }, status: :ok
      return
    end

    rel = Adviser.find(params[:adviser_id])
    rel.update!(user_params)
    respond_with rel, root: 'investor'
  end

  # DELETE /api/v2/supervisor/advisers/:adviser_id
  def destroy_adviser
    # TODO: Crer una respuesta global que funcione
    if current_supervisor.nil? then
      render json: { code: 200, message: 'Acceso no autorizado' }, status: :ok
      return
    end

    ActiveRecord::Base.transaction do
      adviser = Adviser.find(params[:adviser_id])
      adviser.update(
        active: false,
        rut: 'D_' + adviser.rut,
        email: 'DEL_' + adviser.email
      )

      if !SupervisorAdviser.find_by_adviser_id(params[:adviser_id]).nil? then
        SupervisorAdviser.find_by_adviser_id(params[:adviser_id]).delete
      end
    end

    render json: {
      code: :ok, message: 'Asesor eliminado'
    }, status: :ok
  end

  # POST /api/v2/supervisor/advisers/:adviser_id/investors/:relation_id
  def add_investor_to_adviser
    # TODO: Crer una respuesta global que funcione
    if current_supervisor.nil? then
      render json: { code: 200, message: 'Acceso no autorizado' }, status: :ok
      return
    end

    if !is_child_adviser?(params[:adviser_id]) || !is_child_relation?(params[:relation_id]) then
      render json: { code: :bad_request, message: 'El asesor o el inversionista no pertenecen a este vendor' }, status: :bad_request
      return
    end

    if AdviserRelation.where(adviser_id: params[:adviser_id], relation_id: params[:relation_id]).nil? then
      adviser_investor = AdviserRelation.create!(
        adviser_id: params[:adviser_id],
        relation_id: params[:relation_id]
      )
    end

    render json: {
      code: :ok, message: 'Relación Asesor/Inversionista creada'
    }, status: :ok
  end

  # DELETE /api/v2/supervisor/advisers/:adviser_id/investors/:relation_id
  def delete_investor_on_adviser
    # TODO: Crer una respuesta global que funcione
    if current_supervisor.nil? then
      render json: { code: 200, message: 'Acceso no autorizado' }, status: :ok
      return
    end

    if !is_child_adviser?(params[:adviser_id]) || !is_child_relation?(params[:relation_id]) then
      render json: { code: :bad_request, message: 'El asesor o el inversionista no pertenecen a este vendor' }, status: :bad_request
      return
    end

    AdviserRelation.where(adviser_id: params[:adviser_id], relation_id: params[:relation_id]).first.delete

    render json: {
      code: :ok, message: 'Relación Asesor/Inversionista eliminada'
    }, status: :ok
  end

  # Investors

  # GET /api/v2/supervisor/investors
  def get_investors
    # TODO: Crer una respuesta global que funcione
    if current_supervisor.nil? then
      render json: { code: 200, message: 'Acceso no autorizado' }, status: :ok
      return
    end

    respond_with relations.order(first_name: :asc, last_name: :asc),
      simplified: true,
      root: 'investors'
  end

  # GET /api/v2/supervisor/advisers/:adviser_id/investors
  def get_adviser_investors
    # TODO: Crear una respuesta global que funcione
    if current_supervisor.nil?
      render json: { code: 200, message: 'Acceso no autorizado' }, status: :ok
      return
    end

    adviser = Adviser.find(params[:adviser_id])

    respond_with adviser.relations.order(first_name: :asc, last_name: :asc),
    simplified: true,
    root: 'investors'
  end

  # GET /api/v2/supervisor/investors/complex
  def get_investors_complex
    # TODO: Crer una respuesta global que funcione
    if current_supervisor.nil? then
      render json: { code: 200, message: 'Acceso no autorizado' }, status: :ok
      return
    end

    respond_with relations.order(first_name: :asc, last_name: :asc),
      deep: true,
      real_estate: false,
      root: 'investors'
  end

  # GET /api/v2/supervisor/investors/:relation_id
  def show_investor
    # TODO: Crer una respuesta global que funcione
    if current_supervisor.nil? then
      render json: { code: 200, message: 'Acceso no autorizado' }, status: :ok
      return
    end

    respond_with relations.where(id: params[:relation_id]).first,
      real_estate: false,
      root: 'investor'
  end

  # POST /api/v2/supervisor/investors
  def create_investor
    # TODO: Crer una respuesta global que funcione
    if current_supervisor.nil? then
      render json: { code: 200, message: 'Acceso no autorizado' }, status: :ok
      return
    end

    if !params.include?('adviser_id') then
      render json: { code: :bad_request, message: 'Debes crear un inversionista asociado con un asesor' }, status: :bad_request
      return
    end

    investor = Relation.create!(
      user_params.merge(password: default_user_password, user: default_admin_user)
    )

    # Crea una relacion con el asesor
    if params.has_key?(:adviser_id) then
      AdviserRelation.create!(
        relation: investor,
        adviser_id: params[:adviser_id]
      )
    end

    respond_with investor, root: 'investor', advisers: true
  end

  # PATCH /api/v2/supervisor/investors/:relation_id
  def update_investor
    # TODO: Crer una respuesta global que funcione
    if current_supervisor.nil? then
      render json: { code: 200, message: 'Acceso no autorizado' }, status: :ok
      return
    end

    rel = relations.where(id: params[:relation_id]).first

    if rel.nil? then
      render json: { code: :bad_request, message: 'El inversionista no existe o no esta bajo este supervisor' }, status: :bad_request
      return
    end

    rel.update!(user_params)
    respond_with rel, root: 'investor'
  end

  # DELETE /api/v2/supervisor/investors/:relation_id
  def destroy_investor
    # TODO: Crer una respuesta global que funcione
    if current_supervisor.nil? then
      render json: { code: 200, message: 'Acceso no autorizado' }, status: :ok
      return
    end

    ActiveRecord::Base.transaction do
      relations.where(id: params[:relation_id]).update(
        active: false,
        user: default_admin_user
      )

      if !AdviserRelation.find_by_relation_id(params[:relation_id]).nil? then
        AdviserRelation.find_by_relation_id(params[:relation_id]).delete
      end
    end

    render json: {
      code: :ok, message: 'Inversionista eliminado'
    }, status: :ok
  end

  private

  def supervisors
    Supervisor.where(vendor_id: current_supervisor.vendor_id)
  end

  def advisers
    current_supervisor.advisers
  end

  def is_child_adviser? id
    advisers.map(&:id).include?(id.to_i) ? true : false
  end

  def relations
    relations = []
    current_supervisor.advisers.map do |adviser|
      relations += adviser.relations.map(&:id)
    end
    Relation.where(id: relations)
  end

  def is_child_relation? id
    relations.map(&:id).include?(id.to_i) ? true : false
  end

  def default_user_password
    user_params[:rut].delete('.').delete('-').delete(' ')[0..5]
  end

  def user_params
    params.permit(
      :first_name,
      :last_name,
      :rut,
      :phone,
      :email
    )
  end
end
