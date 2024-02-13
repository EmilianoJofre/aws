class Api::V1::DemoSubAccountSerializer < Api::V1::BaseSerializer
  attributes :id, :currency, :sub_account_id

  attribute :memberships, if: :deep?

  def memberships
    object.memberships.active.map do |membership|
      Api::V1::DemoMembershipSerializer.new(membership)
    end
  end
end
