class Api::V2::AccountSerializer < Api::V2::BaseSerializer
  attributes :id, :name, :rut, :email, :account_type, :bank, :country
  attribute :sub_accounts, if: :send_sub_accounts

  def sub_accounts
    object.sub_accounts.map do |sub_account|
      Api::V2::SubAccountSerializer.new(sub_account, deep: deep?, memberships: @instance_options[:memberships], real_estate: real_estate?)
    end
  end

  def send_sub_accounts
    return true if deep? || sub_accounts?

    false
  end
end
