class Api::V1::SubAccountSerializer < Api::V1::BaseSerializer
  attributes :id, :currency, :sub_account_id, :property_type

  attribute :memberships, if: :send_memberships


  def memberships
    object.memberships.active.map do |membership|
      Api::V1::MembershipSerializer.new(membership, real_estate: @instance_options[:real_estate], liability: @instance_options[:liability])
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
