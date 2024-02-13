class Api::V1::RelationHistoriesController < Api::V1::BaseController
  skip_before_action :authenticate_user!
  before_action :authenticate_users!
  
  def update
    relation_history.update!(
      balances_values: new_balances,
      wallet_values: new_wallet
    )
    respond_with relation_history
  end

  private

  def relation_history
    @relation_history ||= RelationHistory.find(params[:id])
  end

  def dates_to_remove
    @dates_to_remove ||= params[:dates_to_remove]&.map { |date| Date.parse(date).to_s }
  end

  def balances_values
    @balances_values ||= JSON.parse(relation_history.balances_values)
  end

  def wallet_values
    @wallet_values ||= JSON.parse(relation_history.wallet_values)
  end

  def new_balances
    balances_values.except(*dates_to_remove).to_json
  end

  def new_wallet
    wallet_values.except(*dates_to_remove).to_json
  end
end
