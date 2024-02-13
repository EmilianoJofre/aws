class Api::V1::WalletWithdrawalsController < Api::V1::BaseWalletController
  skip_before_action :verify_authenticity_token, if: :json_request?
  skip_before_action :authenticate_user!
  before_action :authenticate_users!
  
  def index
    respond_with WalletWithdrawal.where(sub_account: sub_account).order('date DESC')
  end

  def update
    wallet_withdrawal.update!(wallet_params)
    respond_with wallet_withdrawal
  end

  def create
    respond_with sub_account.wallet_withdrawals.create!(wallet_params)
  end

  def destroy
    respond_with wallet_withdrawal.destroy!
  end

  def month_movements
    month = Time.zone.parse(params[:month])
    respond_with WalletWithdrawal.where(
      sub_account: sub_account, date: month.beginning_of_month...(month.end_of_month + 1)
    )
  end
end

private

def wallet_withdrawal
  @wallet_withdrawal ||= WalletWithdrawal.find(params[:id])
end
