class Api::V1::WalletWithdrawalSerializer < Api::V1::BaseSerializer
  attributes :id, :amount, :date, :comment
end
