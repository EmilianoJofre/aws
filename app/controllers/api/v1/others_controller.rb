# rubocop:disable Layout/LineLength
class Api::V1::OthersController < Api::V1::BaseController
  skip_before_action :authenticate_user!
  before_action :authenticate_users!
  skip_before_action :verify_authenticity_token, if: :json_request?

  def index
    if others_memberships
      respond_with others_memberships, root: "others"
    else
      render json: { code: 404, message: "SubAccount doesn't exist" }
    end 
  end

  def show
    respond_with others_membership
  end

  def create
    ActiveRecord::Base.transaction do
      asset = InvestmentAsset.create!(params_asset_others.merge(params_asset_others_permit).merge(currency: sub_account.currency))
      membership = sub_account.memberships.create!(
        create_membership_params.merge(investment_asset_id: asset.id)
      )

      others_membership = OthersMembership.create!(params_others_permit.merge(membership_id: membership.id))

      money_movement = membership.money_movements.create!(
        sub_account_id: membership.sub_account_id,
        movement_type: 0,
        average_price: params[:total_investment],
        quotas: 1,
        date: Time.now
      )

      price_change = asset.price_changes.create!(
        value: params[:total_investment],
        price_changed_at: Time.current,
        money_movement_id: money_movement.id
      )

      respond_with others_membership

    end

  end

  def update
    others_membership.update(params_others_permit)
    respond_with others_membership
  end
  
  def update_external_valorization
    ActiveRecord::Base.transaction do

      others_membership.membership.external_value_changes.create(
        total_value: params[:valorization],
        date: params[:date],
        valuer: params[:valuer_name],
        type_valuer: 1
      )

      respond_with others_membership
    end
  end

  def destroy
    others_membership.membership.update(hidden: true)
    render json: { code: :ok, message: 'Others membership deleted' }, status: :ok 
  end
  
  private

  def others_memberships
    Membership.where(sub_account_id: sub_account_ids).where.not(hidden: true).joins("inner join investment_assets on investment_assets.id = memberships.investment_asset_id").where("investment_assets.asset_type = ?", InvestmentAsset.asset_types[:others])
  end

  def others_membership
    OthersMembership.find(params[:id])
  end

  def sub_account
    SubAccount.find_by(id: sub_account_id)
  end

  def sub_account_id
    params.require(
      :sub_account_id
    )
  end

  def sub_account_ids
    SubAccount.find_by(id: params['sub_account_id'])
  end

  def relation_id
    params.require(
      :relation_id
    )
  end

  def params_asset_others_permit
    params.permit(
      :name,
    )
  end

  def params_asset_others
    {
      is_custom: false,
      valid_asset: true,
      asset_type: 8,
      asset_id: params_others_asset_id
    }
  end

  def create_membership_params
    params.permit(
      :sub_account_id,
    )
  end

  def params_others_permit
    params.permit(
      :name,
      :description,
      :total_investment, 
      :quantity
    )
  end

  def params_others_asset_id
    "others_#{params[:name].parameterize(separator: '_')}_#{params['sub_account_id']}"
  end

end
