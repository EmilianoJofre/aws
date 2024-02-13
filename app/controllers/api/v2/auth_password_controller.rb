class Api::V2::AuthPasswordController < Devise::PasswordsController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_users!, except: [:reset_password, :change_password]
  respond_to :json

  # GET /auth/password/new
  def new
    # empty
  end

  # POST /auth/password
  def create
    render json: { code: 200, message: 'CREATE' }, status: :ok
  end

  # GET /auth/password/edit?reset_password_token=abcdef
  def edit
    # empty
  end

  # PUT /auth/password
  def update
    if !current.valid_password? params[:old_password] then
      render json: {
        code: :bad_request, message: 'Contraseña antigua incorrecta'
      }, status: :bad_request and return
    end

    current.reset_password(params[:new_password], params[:new_password])

    render json: {
      code: 200, message: 'Contraseña actualizada', user: current
    }, status: :ok and return
  end

  # POST /auth/reset_password
  def reset_password
    if resource.nil? then
      render json: {
        code: :forbidden, message: 'El mail no existe en ValueList'}, status: :forbidden and return  
    end
    
    can_reset = V2::ResetUserPassword.for(user_type: model, email: params[:email], request: request)

    if can_reset then
      render json: {
        code: 200, message: 'Se ha enviado el correo para reseteo de contraseña'}, status: :ok and return
    else
      render json: {
        code: :conflict, message: 'No se pudo generar el token para resetear la contraseña.'}, status: :conflict and return
    end
  end

  # POST /auth/change_password
  def change_password
    if !params[:type].present? || !params[:token].present? || !params[:password].present? then
      render json: {
        code: :bad_request, message: 'Faltan parametros'}, status: :bad_request and return 
    end

    response = model(params[:type]).reset_password_by_token(
      reset_password_token: params[:token],
      password: params[:password],
      password_confirmation: params[:password]
    )

    if response.id.nil? then
      render json: {
        code: :bad_request, message: 'Token invalido'}, status: :bad_request and return 
    end

    render json: {
      code: 200, message: 'Contraseña actualizada.' }, status: :ok and return
  end

  protected

  def current
    current_user || current_supervisor || current_adviser || current_relation 
  end

  def resource
    admin = User.find_for_database_authentication(email: params[:email])
    return admin if !admin.nil?

    supervisor = Supervisor.find_for_database_authentication(email: params[:email])
    return supervisor if !supervisor.nil?

    adviser = Adviser.find_for_database_authentication(email: params[:email])
    return adviser if !adviser.nil?

    investor = Relation.find_for_database_authentication(email: params[:email])
    return investor if !investor.nil?

    return nil
  end

  def model type = nil
    t = type.nil? ? resource.type : type
    case t
    when 'admin'
      return 'user'.capitalize.constantize
    when 'supervisor'
      return 'supervisor'.capitalize.constantize
    when 'adviser'
      return 'adviser'.capitalize.constantize
    when 'investor'
      return 'relation'.capitalize.constantize
    end
  end

  def authenticate_users!
    unless user_signed_in? || relation_signed_in? || supervisor_signed_in? || adviser_signed_in?
      render json: {
        code: :unauthorized, message: 'Logged in unsuccessfully. Mail, password or type incorrect.'
      }, status: :unauthorized
    end
  end
end
