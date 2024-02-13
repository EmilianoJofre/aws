class Api::V1::SummaryController < Api::V1::BaseController
  skip_before_action :authenticate_user!
  # before_action :authenticate_users!

  def index
    respond_with relation, deep: true, root: "summary"
  end

  def estate_distribution
    estate_distribution = {}
    balance = relation.balance_by_asset_type
    respond_with balance
  end

  def estate_distribution_by_currency
    estate_distribution = {}
    balance = relation.balance_by_currency
    respond_with balance
  end

  def estate_distribution_by_country
    respond_with relation.balance_by_country_2
  end

  def estate_distribution_by_sustainability
    balance = relation.balance_by_sustainability
    respond_with balance
  end

  def top_investments
    balance = relation.top_investment_assets
    respond_with balance
  end
  
  def estate_distribution_by_institution
    estate_distribution = {}
    balance = relation.balance_by_institution
    respond_with balance
  end
  def investments_distribution
    respond_with relation.investments_distribution
  end

  def chart_history
    respond_with SelectedAccountsBalanceJob.perform_now(relation, account_ids, params[:window], true), summary: true
  end

  private

  def relation
    demo? ? DemoRelation.find_by(id: relation_id) : Relation.find_by(id: relation_id)
  end

  def accounts
    Account.where(relation_id: relation.id)
  end

  def account_ids
    accounts.map {|a| a.id.to_s}
  end

  def relation_id
    params.require(
      :relation_id
    )
  end

  def demo?
    params[:is_demo] == 'true'
  end
end
