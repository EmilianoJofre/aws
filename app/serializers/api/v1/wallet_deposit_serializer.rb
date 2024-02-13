class Api::V1::WalletDepositSerializer < Api::V1::BaseSerializer
  attributes :id, :amount, :date, :comment
end
