class Api::V1::BaseController < Api::BaseController
  include Pundit
  include ApiErrorConcern

  before_action :authenticate_user!

  before_action do
    self.namespace_for_serializer = ::Api::V1
  end

  def authenticate_users!

  end

  def pundit_user
    current_user || current_relation || current_supervisor || current_adviser
  end

  def json_request?
    request.format.symbol == :json
  end
end
