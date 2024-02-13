# rubocop:disable Layout/LineLength
class Api::V1::RealEstatesController < Api::V1::BaseController
  skip_before_action :authenticate_user!
  before_action :authenticate_users!
  skip_before_action :verify_authenticity_token, only: [:create, :edit, :update_external_valorization]

  def index
    respond_with sub_account.memberships.joins("inner join investment_assets on investment_assets.id = memberships.investment_asset_id").where("investment_assets.asset_type in (7)").active.without_custom_asset, investment_asset: true, movements: true, real_estate: true, root: "real_estates"
  end

  def create

    ActiveRecord::Base.transaction do
      asset = InvestmentAsset.create!(params_asset_real_estate.merge(params_asset_real_estate_permit).merge(currency: sub_account.currency))
      membership = sub_account.memberships.create!(
        create_membership_params.merge(investment_asset_id: asset.id)
      )

      real_estate = RealEstate.create!(params_real_estate_permit.merge(membership_id: membership.id))

      money_movement = membership.money_movements.create!(
        sub_account_id: membership.sub_account_id,
        movement_type: 0,
        average_price: params[:total_inversion],
        quotas: 1,
        date: Time.now
      )

      # ProcessMoneyMovementJob.perform_now money_movement

      price_change = asset.price_changes.create!(
        value: params[:total_inversion],
        price_changed_at: Time.current,
        money_movement_id: money_movement.id
      )

      # ProcessPriceChangeJob.perform_now price_change

      respond_with real_estate

    end

  end

  def update
    real_estate.update(params_real_estate_permit)
    respond_with real_estate
  end
  
  def update_external_valorization
    ActiveRecord::Base.transaction do
      
      real_estate = real_estate_by_role
      render :json => { :error => 'El rol ingresado no existe' }, :status => :bad_request and return if real_estate.nil?

      real_estate.re_value_changes.create(
        total_value: params[:valorization],
        date: params[:date],
        valuer: params[:valuer_name],
        type_valuer: 1
      )

      respond_with real_estate
    end
  end



  def liquidate
    unless membership.quotas_balance&.zero? || membership.updated_quota_average_price&.zero?
      MoneyMovement.create!(
        quotas: membership.quotas_balance,
        date: Time.current,
        sub_account: membership.sub_account,
        membership: membership,
        movement_type: 'sale',
        average_price: membership.updated_quota_average_price
      )
    end
    respond_with membership.update!(hidden: true), movements: true
  end

  def enable
    membership.hidden = false
    membership.save
    respond_with membership
  end

  private

  def real_estate
    RealEstate.find(params[:id])
  end

  def real_estate_by_role
    RealEstate.find_by_role(params[:role])
  end

  def params_real_estate_permit
    params.permit(
      :name,
      :role,
      :commune,
      :total_inversion
    )
  end

  def params_asset_real_estate_permit
    params.permit(
      :name,
    )
  end

  def params_asset_real_estate
    {
      is_custom: false,
      valid_asset: true,
      asset_type: 7,
      asset_id: params_real_estate_asset_id
    }
  end

  def params_real_estate_asset_id
    "real_estate_#{params[:name].parameterize(separator: '_')}_#{params['sub_account_id']}"
  end

  def sub_account
    demo? ? DemoSubAccount.find_by(id: sub_account_id) : SubAccount.find_by(id: sub_account_id)
  end

  def membership_by_id
    @membership_by_id ||= demo? ? DemoMembership.find(params[:id]) : Membership.find(params[:id])
  end

  def membership
    @membership ||= demo? ? DemoMembership.find(edit_params['membership_id']) : Membership.find(edit_params['membership_id'])
  end

  def sub_account_id
    params.require(
      :sub_account_id
    )
  end

  def create_membership_params
    params.permit(
      :sub_account_id,
    )
  end

  def edit_params
    params.permit(:membership_id, :hidden)
  end

  def demo?
    params[:is_demo] == 'true'
  end
end
# rubocop:enable Layout/LineLength
