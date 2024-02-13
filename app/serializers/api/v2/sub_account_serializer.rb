class Api::V2::SubAccountSerializer < Api::V2::BaseSerializer
  attributes :id, :currency, :sub_account_id, :property_type

  attribute :memberships, if: :send_memberships


  def memberships
    object.memberships.active.map do |membership|
      Api::V2::MembershipSerializer.new(membership, deep: deep?, real_estate: real_estate?)
    end
  end

  def send_memberships
    return true if deep? || memberships?

    false
  end

  def property_type
    object.sub_account_id
  end
end
