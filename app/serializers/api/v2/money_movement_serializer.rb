class Api::V2::MoneyMovementSerializer < Api::V2::BaseSerializer
  attributes :id, :average_price, :quotas, :date, :movement_type, :amount, :account
  attribute :asset_id, if: :with_ticker?

  belongs_to :sub_account

  def account
    Api::V2::AccountSerializer.new(object.account)
  end

  def with_ticker?
    @instance_options[:with_ticker]
  end
end
