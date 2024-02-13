# rubocop:disable Layout/LineLength
class Api::V1::PensionFundsController < Api::V1::BaseController
  skip_before_action :authenticate_user!
  before_action :authenticate_users!

  def index
    respond_with sub_account.memberships.joins("inner join investment_assets on investment_assets.id = memberships.investment_asset_id").where("investment_assets.asset_type in (6)").active.without_custom_asset,
    investment_asset: true, movements: true, root: "pension_funds"
  end

  def create
    respond_with sub_account.memberships.create!(create_params)
  end

  def update
    respond_with membership_by_id.update(edit_params)
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

  def create_params
    params.permit(
      :sub_account_id,
      :investment_asset_id
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
