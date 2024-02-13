# rubocop:disable Layout/LineLength
class Api::V1::ExternalRealEstatesController < Api::V1::BaseController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  before_action :authenticate_api_key

  def index
    real_estates = ActiveRecord::Base.connection.execute("
      select re.id, a.rut rut, re.commune, re.role, re.force_update, (select created_at from re_value_changes rvc where rvc.real_estate_id = re.id order by id desc limit 1) last_update
      from accounts a
      inner join sub_accounts sa on sa.account_id = a.id
      inner join memberships m on m.sub_account_id = sa.id
      inner join investment_assets ia on ia.id = m.investment_asset_id
      inner join real_estates re on re.membership_id = m.id
      where (ia.asset_type in (7));"
    )

    respond_with real_estates, root: "real_estate"
  end

  def update
    params[:force_update] = false
    currency = real_estate_to_edit.membership.sub_account.currency
    uf = UfPrice.step_business_day

    if currency == 'UF' then
      params[:fiscal_appraisal] = params[:fiscal_appraisal].to_i / uf
    end

    if currency == 'CLP' then
      params[:builded_value] = params[:builded_value].to_i * uf
      params[:area_value] = params[:area_value].to_i * uf
      params[:total_value] = params[:total_value].to_i * uf
    end

    if currency == 'USD' then
      dollar = DollarPrice.step_business_day
      params[:fiscal_appraisal] = params[:fiscal_appraisal].to_i / dollar
      params[:builded_value] = (params[:builded_value].to_i * uf) / dollar
      params[:area_value] = (params[:area_value].to_i * uf) / dollar
      params[:total_value] = (params[:total_value].to_i * uf) / dollar
    end

    if currency == 'EUR' then
      euro = EuroPrice.step_business_day
      params[:fiscal_appraisal] = params[:fiscal_appraisal].to_i / euro
      params[:builded_value] = (params[:builded_value].to_i * uf) / euro
      params[:area_value] = (params[:area_value].to_i * uf) / euro
      params[:total_value] = (params[:total_value].to_i * uf) / euro
    end

    if currency == 'MXN' then
      mxn = MxnPrice.step_business_day
      params[:fiscal_appraisal] = params[:fiscal_appraisal].to_i / mxn
      params[:builded_value] = (params[:builded_value].to_i * uf) / mxn
      params[:area_value] = (params[:area_value].to_i * uf) / mxn
      params[:total_value] = (params[:total_value].to_i * uf) / mxn
    end
    
    if currency == 'COP' then
      cop = CopPrice.step_business_day
      params[:fiscal_appraisal] = params[:fiscal_appraisal].to_i / cop
      params[:builded_value] = (params[:builded_value].to_i * uf) / cop
      params[:area_value] = (params[:area_value].to_i * uf) / cop
      params[:total_value] = (params[:total_value].to_i * uf) / cop
    end

    if currency == 'CRC' then
      crc = CrcPrice.step_business_day
      params[:fiscal_appraisal] = params[:fiscal_appraisal].to_i / crc
      params[:builded_value] = (params[:builded_value].to_i * uf) / crc
      params[:area_value] = (params[:area_value].to_i * uf) / crc
      params[:total_value] = (params[:total_value].to_i * uf) / crc
    end

    if real_estate_to_edit.update(real_estate_params) then
      ReValueChange.create(
        real_estate_id: real_estate_to_edit.id, 
        builded_value: real_estate_value_params[:builded_value], 
        area_value: real_estate_value_params[:area_value], 
        total_value: real_estate_value_params[:total_value],
        date: Time.current,
        valuer: "VL",
        type_valuer: 0
      )

      price_change = real_estate_to_edit.membership.investment_asset.price_changes.create!(
        value: real_estate_value_params[:total_value],
        price_changed_at: Time.current
      )

      # ProcessPriceChangeJob.perform_later price_change

      render :json => { :message => 'Bien raíz actualizada', rol: real_estate_to_edit.role }, :status => :ok
    else
      render :json => { :error => 'Ocurrió un error al actualizar el bien raíz', rol: real_estate_to_edit.role }, :status => :internal_server_error
    end
  end

  private

  def real_estate_params
    params.permit(
      :address,
      :lat,
      :lon,
      :location_sql,
      :asset_destination,
      :contributions,
      :fiscal_appraisal,
      :area,
      :builded_area,
      :year,
      :force_update
    )
  end

  def real_estate_value_params
    params.permit(
      :builded_value,
      :area_value,
      :total_value
    )
  end

  def real_estate_to_edit
    @real_estate_to_edit ||= RealEstate.find(params[:id])
  end

  def authenticate_api_key
    return if ENV["APIKEYS"].split(',').include? request.headers["X-API-KEY"]
    render :json => { :error => 'Tienes que incluir la API-KEY correcta para acceder a la información' }, :status => :unauthorized
  end
end
# rubocop:enable Layout/LineLength
