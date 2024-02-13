class Api::V1::DemoAccountSerializer < Api::V1::BaseSerializer
  attributes :id, :name, :rut, :email, :bank
  attribute :sub_accounts, if: :deep?

  def sub_accounts
    object.sub_accounts.map do |sub_account|
      Api::V1::DemoSubAccountSerializer.new(sub_account, deep: true)
    end
  end
end
