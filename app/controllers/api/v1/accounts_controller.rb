# rubocop:disable Layout/LineLength
class Api::V1::AccountsController < Api::V1::BaseController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, if: :json_request?
  before_action :authenticate_users!

  def index
    @deep = params[:deep]
    @sub_accounts = params[:sub_accounts]
    @memberships = params[:memberships]
    respond_with relation_accounts, root: "accounts", deep: @deep, sub_accounts: @sub_accounts, memberships: @memberships 
  end

  def asset_type_filter
    respond_with relation_accounts, root: "accounts"
  end

  def create
    # TODO Agregar "Sin institucion al seed"
    params[:bank_id] = Bank.find_by_name('Sin Institución').id if params[:bank_id].blank?
    params[:country_id] = Country.find_by_name('Sin país').id if params[:country_id].blank?
    respond_with relation.relation_accounts.create!(account_params)
  end

  def update
    account_to_edit.update(account_params)
    respond_with account_to_edit
  end

  def destroy
    respond_with account_to_edit.destroy!
  end

  private

  def relation_accounts
    demo? ? @relation_accounts ||= relation.demo_relation_accounts.includes(:bank) : @relation_accounts ||= relation.relation_accounts.includes(:bank)

    if !defined?(params[:asset_type]).nil? && !params[:asset_type].nil? && params[:asset_type] != "" then
      return @relation_accounts.with_type(Account.account_types[params[:asset_type].parameterize.underscore.to_sym])
    end

    return @relation_accounts
  end

  def account_to_edit
    @account_to_edit ||= Account.find(params[:id])
  end

  def relation_id
    params.require(
      :relation_id
    )
  end

  def account_params
    params.permit(
      :name,
      :rut,
      :email,
      :bank_id,
      :account_type,
      :country_id
    )
  end

  def relation
    Relation.find_by(id: relation_id)
  end

  def demo?
    params[:is_demo] == 'true'
  end
end
# rubocop:enable Layout/LineLength
