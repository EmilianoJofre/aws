class Api::V1::DemoMembershipSerializer < Api::V1::BaseSerializer
  attributes :id, :investment_asset, :quotas_balance,
             :amount_invested_balance, :amount_updated_balance, :incomes_balance,
             :quota_average_price, :updated_quota_average_price

  def investment_asset
    Api::V1::DemoInvestmentAssetSerializer.new(object.investment_asset)
  end

  attribute :money_movements, if: :movements?

  def money_movements
    membership_movements.map do |movement|
      serializer = Api::V1::MoneyMovementSerializer.new(movement)
      puts_association(serializer)
    end
  end

  def membership_movements
    object.money_movements.valid.order('date DESC')
  end

  def movements?
    @instance_options[:movements]
  end
end
