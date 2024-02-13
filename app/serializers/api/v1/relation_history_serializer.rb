class Api::V1::RelationHistorySerializer < Api::V1::BaseSerializer
  attributes :id, :next_chart_update, :last_updated, :balances #, :wallet

  def next_chart_update
    CronUtils.next_ocurrence('update_charts').to_s
  end
  
  def last_updated
    PriceChange.from_file.last&.price_changed_at.to_s
  end

  def wallet
    JSON.parse(object.wallet_values)
  end

  def balances
    JSON.parse(object.balances_values)
  end
end
