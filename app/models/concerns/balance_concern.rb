module BalanceConcern
  extend ActiveSupport::Concern

  def balance(date = Time.current)
    memberships.reduce({ CLP: 0, USD: 0, EUR: 0, UF: 0, MXN: 0, COP: 0, CRC: 0 }) do |balance, membership|
      membership_balance = membership.balance(date)
      balance[:CLP] += membership_balance[:CLP]
      balance[:USD] += membership_balance[:USD]
      balance[:EUR] += membership_balance[:EUR]
      balance[:UF] += membership_balance[:UF]
      balance[:MXN] += membership_balance[:MXN]
      balance[:COP] += membership_balance[:COP]
      balance[:CRC] += membership_balance[:CRC]
      balance
    end
  end
end
