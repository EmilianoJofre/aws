class Ledgerizer::ProcessUserQuotaWithdrawal < PowerTypes::Command.new(:user, :money_movement)
  include Ledgerizer::Execution::Dsl
  include MoneyMovementConcern

  def perform
    execute_quota_withdrawal_entry(
      tenant: @user, document: @money_movement, datetime: @money_movement.date
    ) do
      debit(account: :issued_quotas, accountable: investment_asset, amount: quotas)
      credit(account: :quotas, accountable: membership, amount: quotas)
    end
  end

  private

  def quotas
    Money.from_amount(@money_movement.quotas, 'CLP')
  end
end
