class Api::BaseController < PowerApi::BaseController
  def authenticate_api_key
    return if ENV["APIKEYS"].split(',').include? request.headers["X-API-KEY"]
    render :json => { :error => 'Tienes que incluir la API-KEY correcta para acceder a la información' }, :status => :unauthorized
  end
end
