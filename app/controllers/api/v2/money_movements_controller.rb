class Api::V2::MoneyMovementsController < Api::V2::BaseController
  skip_before_action :authenticate_user!
  before_action :authenticate_users!

  def index
    data = relation_money_movements.page(params[:page]).per(params[:limit_value])

    serializer = ActiveModelSerializers::SerializableResource.new(data, each_serializer: Api::V1::MoneyMovementSerializer, with_ticker: true)

    render json: { 
      data: serializer, 
      total: relation_money_movements.count,
      limit_value: data.limit_value,
      total_pages: data.total_pages,
      current: data.current_page
    }
  end

  private

  def relation
    Relation.find(params['relation_id'])
  end

  def current

  end

  def relation_money_movements
    @relation_money_movements ||= relation.money_movements.includes(
      membership: :investment_asset, sub_account: :account
    ).valid.order('date DESC')
  end

  def demo?
    params[:is_demo] == 'true'
  end
end
