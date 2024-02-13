class Api::V1::DemoMoneyMovementSerializer < Api::V1::BaseSerializer
  attributes :id, :average_price, :quotas, :date, :movement_type, :amount, :account
  attribute :asset_id, if: :with_ticker?

  belongs_to :demo_sub_account

  def account
    Api::V1::DemoAccountSerializer.new(object.account)
  end

  def with_ticker?
    @instance_options[:with_ticker]
  end
end
