class Api::V2::AuthSessionController < Devise::SessionsController
  skip_before_action :verify_authenticity_token, only: [:create]
  respond_to :json

  def create
    session.clear
    if !resource.nil? and resource&.valid_password? params[:user][:password] then
      wrong_vendor and return if !check_vendor(resource) 
      case resource.type
      when 'admin'
        sign_in(:user, resource)
      when 'supervisor'
        sign_in(:supervisor, resource)
      when 'adviser'
        sign_in(:adviser, resource)
      when 'investor'
        sign_in(:relation, resource)
      end
      respond_success resource
    else
      respond_error
    end
  end

  def destroy
    session.clear
    render json: {
      code: 200, message: 'Session ended.'
    }, status: :ok
  end

  protected

  def check_vendor resource
    return true if resource.type == 'admin'
    req_vendor = request.headers.include?('vendor') ? request.headers['vendor'] : 'valuelist'
    current_vendors(resource).map{|i|(i.name.parameterize.tr('-', ''))}.include?(req_vendor)
  end

  def wrong_vendor
    render json: {
      code: :bad_request, message: 'Incorrect Vendor'
    }, status: :bad_request 
  end

  def current_vendors resource
    return Vendor.find_by_sql('select distinct vendor.* from supervisors s
      inner join vendors vendor on vendor.id = s.vendor_id 
      where s.id = ' + resource.id.to_s) if resource.type == 'supervisor'
    return Vendor.find_by_sql('select distinct vendor.* from advisers a
      inner join supervisor_advisers sa on sa.adviser_id = a.id 
      inner join supervisors s on s.id = sa.supervisor_id
      inner join vendors vendor on vendor.id = s.vendor_id 
      where a.id = ' + resource.id.to_s) if resource.type == 'adviser'
    return Vendor.find_by_sql('select distinct vendor.* from relations r
      inner join adviser_relations ar on ar.relation_id = r.id
      inner join supervisor_advisers sa on sa.adviser_id = ar.adviser_id 
      inner join supervisors s on s.id = sa.supervisor_id
      inner join vendors vendor on vendor.id = s.vendor_id 
      where r.id = ' + resource.id.to_s) if resource.type == 'investor'
  end

  def respond_success resource
    render json: {
      code: 200, message: 'Logged in successfully.', user: serialize(resource)
    }, status: :ok
  end

  def respond_error
    render json: {
      code: :unauthorized, message: 'Logged in unsuccessfully. Mail, RUT, password or type incorrect.'
    }, status: :unauthorized
  end

  def resource
    admin = User.find_for_database_authentication(email: params[:user][:email])
    return admin if !admin.nil?

    supervisor = Supervisor.find_for_database_authentication(email: params[:user][:email])
    return supervisor if !supervisor.nil?

    adviser = Adviser.find_for_database_authentication(email: params[:user][:email])
    return adviser if !adviser.nil?

    investor = Relation.find_for_database_authentication(email: params[:user][:email])
    if investor.nil? then
      # return nil if !Chilean::Rutify.valid_rut?(params[:user][:email]) 
      rut = params[:user][:email]
      investor = Relation.find_for_database_authentication(rut: rut)
      return investor if !investor.nil?
    else
      return investor
    end

    return nil
  end

  def serialize resource
    case resource.type
    when 'admin'
      return ActiveModelSerializers::SerializableResource.new(resource, each_serializer: Api::V2::UserSerializer, adapter: :attributes)
    when 'supervisor'
      return ActiveModelSerializers::SerializableResource.new(resource, each_serializer: Api::V2::SupervisorSerializer, adapter: :attributes)
    when 'adviser'
      return ActiveModelSerializers::SerializableResource.new(resource, each_serializer: Api::V2::AdviserSerializer, adapter: :attributes)
    when 'investor'
      return ActiveModelSerializers::SerializableResource.new(resource, each_serializer: Api::V2::RelationSerializer, adapter: :attributes)
    end
  end
end
