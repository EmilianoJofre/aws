class Api::V1::SubAccountsController < Api::V1::BaseController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, if: :json_request?
  before_action :authenticate_users!

  def index
    respond_with account.sub_accounts, root: "sub_accounts"
  end

  def create
    respond_with account.sub_accounts.create!(sub_account_params)
  end

  def update
    sub_account_to_edit.update!(sub_account_params)
    respond_with sub_account_to_edit
  end

  def destroy
    respond_with sub_account_to_edit.destroy!
  end

  def membership
    if membership_params['investment_asset_id']
      membership = Membership.find_by(
        investment_asset_id: membership_params['investment_asset_id'],
        sub_account_id: membership_params['sub_account_id']
      )
    end
    membership ||= InvestmentAsset.find_by(asset_id: custom_asset_id)&.memberships&.last

    respond_with membership if membership
  end

  def custom_memberships
    respond_with sub_account.memberships.active.with_custom_asset,
    investment_asset: true, movements: true, root: "memberships"
  end

  def custom_asset
    ActiveRecord::Base.transaction do
      asset = InvestmentAsset.create!(custom_asset_params.merge(custom_params))
      membership = sub_account.memberships.create!(
        custom_membership_params.merge(investment_asset_id: asset.id)
      )

      respond_with membership
    end
  end

  def roles
    respond_with RealEstate.where(membership: SubAccount.find(sub_account_id).memberships), each_serializer: Api::V1::RolesSerializer, root: 'roles'
  end

  private

  def account
    demo? ? DemoAccount.find_by(id: account_id) : Account.find_by(id: account_id)
  end

  def sub_account
    demo? ? DemoSubAccount.find_by(id: sub_account_id) : SubAccount.find_by(id: sub_account_id)
  end

  def sub_account_to_edit
    @sub_account_to_edit ||= SubAccount.find(params[:id])
  end

  def account_id
    params.require(
      :account_id
    )
  end

  def sub_account_id
    params.require(
      :sub_account_id
    )
  end

  def sub_account_params
    params.permit(
      :sub_account_id,
      :currency
    )
  end

  def custom_membership_params
    params.permit(
      :sub_account_id
    )
  end

  def custom_asset_params
    params.permit(
      :name,
      :asset_type,
      :currency
    )
  end

  def membership_params
    params.permit(
      :sub_account_id,
      :name,
      :investment_asset_id
    )
  end

  def custom_params
    {
      is_custom: true,
      valid_asset: true,
      asset_id: custom_asset_id
    }
  end

  def custom_asset_id
    "custom_#{params['name']}_#{params['sub_account_id']}"
  end

  def demo?
    params[:is_demo] == 'true'
  end
end
