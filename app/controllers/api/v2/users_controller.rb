class Api::V2::UsersController < Api::V2::BaseController
  skip_before_action :authenticate_user!

  # TODO: Revisar auntentificaciones en post
  def update_password
    if !user.valid_password? params[:old_password] then
      render json: {
        code: 400, message: 'Contraseña antigua incorrecta'
      }, status: :bad_request and return
    end

    user.reset_password(params[:new_password], params[:new_password])

    render json: {
      code: 200, message: 'Contraseña actualizada'
    }, status: :ok and return

  end

  private

  def user
    User.find(params['user_id'])
  end
end
