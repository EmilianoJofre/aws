class Api::V1::InternalsController < Api::V1::BaseController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  before_action :authenticate_api_key
  
  def clients
    respond_with Relation.all, root: 'clients'
  end

  def aum

    if params.has_key?(:endDate) && !params.has_key?(:startDate) then
      render :json => { :error => 'Imposible hacer request por fechas sin incluir fecha de inicio' }, :status => :bad_request and return
    end

    if !params.has_key?(:startDate) then
      respond_with Aum.order(created_at: 'desc').first and return
    end

    startDate = params.has_key?(:startDate) ? Date.strptime(params[:startDate], '%m/%d/%Y') : nil
    endDate = params.has_key?(:endDate) ? Date.strptime(params[:endDate], '%m/%d/%Y') : nil

    aums = Aum.all
    aums = aums.where('created_at >= ?', startDate) if !startDate.nil?
    aums = aums.where('created_at <= ?', endDate) if !endDate.nil?
    aums = aums.order(created_at: 'desc')

    respond_with aums, root: false
  end

end
