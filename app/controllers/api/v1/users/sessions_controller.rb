class Api::V1::Users::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token, only: [:create]
  respond_to :json

  def create
    respond_to do |format|

      format.json do

        user_type = params[:user][:type]

        resource = get_user_by_type  user_type
        respond_to_on_destroy and return if resource.nil?

        if resource.valid_password? params[:user][:password] then
          sign_in(:user, resource)
          respond_with resource
          
        else
          current_user = nil

          respond_to_on_destroy
        end

      end
    end
  end

  def destroy
    puts "logout"
  end

  protected

  def get_user_by_type  user_type
    if(user_type === 'adviser')
      return User.find_for_database_authentication(email: params[:user][:email])
    end

    if(user_type === 'investor')
      return Relation.find_for_database_authentication(email: params[:user][:email])
    end

    return nil

  end

  def respond_with resource
    sign_in(:user, resource.user)
    render json: {
      status: {code: 200, message: 'Logged in sucessfully.', user: resource}
    }, status: :ok
  end

  def respond_to_on_destroy
    # We actually need to hardcode this as Rails default responder doesn't
    # support returning empty response on GET request
    respond_to do |format|
      format.all { head :bad_request }
      format.any do
        render json: {
          status: {code: 400, message: 'Logged out'}
        }, status: :bad_request    
      end
    end
  end

end