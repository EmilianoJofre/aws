module WalletMovementConcern
  extend ActiveSupport::Concern

  def user
    @user ||= @wallet_movement.user
  end

  def relation
    @relation ||= @wallet_movement.relation
  end

  def account
    @account ||= @wallet_movement.account
  end

  def sub_account
    @sub_account ||= @wallet_movement.sub_account
  end

  def amount
    @amount ||= Money.from_amount(@wallet_movement.amount, @wallet_movement.currency)
  end
end
