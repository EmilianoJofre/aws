class Api::V1::AlternativeNamesController < Api::V1::BaseController
  skip_before_action :verify_authenticity_token, if: :json_request?
  skip_before_action :authenticate_user!
  before_action :authenticate_users!

  def create
    ActiveRecord::Base.transaction do
      AlternativeName.create!(
        name: params[:name],
        membership_id: params[:membership_id]
      )
    end
    render json: {
      code: :ok, message: 'Nombre alternativo creado.'
    }, status: :ok
  end
end
