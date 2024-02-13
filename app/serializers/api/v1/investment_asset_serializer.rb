class Api::V1::InvestmentAssetSerializer < Api::V1::BaseSerializer
  attributes :id, :currency, :asset_id, :name, :asset_type, :sub_sector, :average_annual_cost,
             :mtd, :recovery_level, :qtd, :ytd, :y1, :y3, :y5, :accounts, :sustainability
  attribute :etf_patrimony, if: :relation
  attribute :profitability, if: :relation
  attribute :asset_quota_average_price, if: :relation

  def relation
    @relation ||= instance_options[:relation]
  end

  def accounts
    memberships&.map(&:account)
  end

  def memberships
    @memberships ||= relation&.memberships&.where(investment_asset: object)
  end

  def etf_patrimony
    memberships.sum { |membership| membership_balance(membership) }
  end

  def profitability
    total_amount_invested = memberships.map(&:amount_invested_balance).compact.sum
    return nil if total_amount_invested.zero?

    profit = memberships.map(&:profit).compact.sum
    profit / total_amount_invested
  end

  def asset_quota_average_price
    total_quotas = memberships.map(&:quotas_balance).compact.sum
    return nil if total_quotas.zero?

    total_amount_invested = memberships.map(&:amount_invested_balance).compact.sum
    total_amount_invested / total_quotas
  end

  def membership_balance(membership)
    membership.updated_balance
  end
end
