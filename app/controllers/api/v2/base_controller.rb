class Api::V2::BaseController < Api::BaseController
  include Pundit
  include ApiErrorConcern

  skip_before_action :verify_authenticity_token, if: :json_request?
  before_action :authenticate_user!

  respond_to :json

  before_action do
    self.namespace_for_serializer = ::Api::V2
  end

  def authenticate_users!
    unless user_signed_in? || relation_signed_in? || supervisor_signed_in? || adviser_signed_in?
      raise ValueListErrors::AuthenticationError
    end
  end

  def pundit_user
    current_user || current_relation || current_supervisor || current_adviser
  end

  def current
    current_user || current_relation || current_supervisor || current_adviser
  end

  def json_request?
    request.format.symbol == :json
  end

  # Obtiene un User (ADMIN) por defecto para crear al inversionista (relation)
  def default_admin_user
    User.find_by_email('admin@valuelist.cl')
  end
end
