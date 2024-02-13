module MoneyMovementConcern
  extend ActiveSupport::Concern

  def membership
    @membership ||= @money_movement.membership
  end

  def sub_account
    @sub_account ||= @money_movement.sub_account
  end

  def investment_asset
    @investment_asset ||= membership.investment_asset
  end
end
