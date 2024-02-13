class Api::V1::BaseWalletController < Api::V1::BaseController
  skip_before_action :authenticate_user!, only: [:month_movements]
  before_action :authenticate_users!, only: [:month_movements]

  def month_movements; end

  private

  def sub_account
    SubAccount.find_by(id: sub_account_id)
  end

  def sub_account_id
    params.require(
      :sub_account_id
    )
  end

  def wallet_params
    params.permit(
      :amount,
      :date,
      :comment
    )
  end
end
