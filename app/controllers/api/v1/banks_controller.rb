class Api::V1::BanksController < Api::V1::BaseController
  skip_before_action :authenticate_user!
  before_action :authenticate_users!
  skip_before_action :verify_authenticity_token, if: :json_request?

  def index
    respond_with Bank.all.order(name: :asc)
  end
end