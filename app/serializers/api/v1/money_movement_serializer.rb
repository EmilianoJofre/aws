class Api::V1::MoneyMovementSerializer < Api::V1::BaseSerializer
  attributes :id, :average_price, :quotas, :date, :movement_type, :amount, :fee_number, :fee_outstanding_balance, :account
  attribute :asset_id, if: :with_ticker?

  belongs_to :sub_account

  def date
    date_time_concise object.date
  end

  def account
    Api::V1::AccountSerializer.new(object.account)
  end

  def with_ticker?
    @instance_options[:with_ticker]
  end
end
