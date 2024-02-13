class RelationPolicy < ApplicationPolicy
  def get_investments?
    true
  end

  def get_investments_with_real_estates?
    true
  end

  def get_history_balances?
    true
  end
end
