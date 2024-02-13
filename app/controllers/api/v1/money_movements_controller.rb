class Api::V1::MoneyMovementsController < Api::V1::BaseController
  skip_before_action :verify_authenticity_token, if: :json_request?
  skip_before_action :authenticate_user!
  before_action :authenticate_users!

  def create
    respond_with create_movement
  end

  def index
    respond_with paginate(relation_money_movements), with_ticker: true
  end

  def update
    destroyed = destroy_movement
    respond_with create_movement if destroyed
  end

  def destroy
    respond_with destroy_movement
  end

  private

  def relation
    current_relation || current_user.relations.find(params['relation_id'])
  end

  def relation_money_movements
    @relation_money_movements ||= relation.money_movements.includes(
      membership: :investment_asset, sub_account: :account
    ).valid.order('date DESC')
  end

  def create_movement
    membership.money_movements.create!(
      create_params.merge(
        sub_account_id: membership.sub_account_id,
        date: creation_date
      )
    )
  end

  def money_movement
    @money_movement ||= MoneyMovement.find(money_movement_id)
  end

  def destroy_movement
    Ledgerizer::RevertMoneyMovement.for(money_movement: money_movement)
  end

  def membership
    @membership ||= Membership.find_by(id: membership_id) || money_movement.membership
  end

  def membership_id
    params[:membership_id]
  end

  def money_movement_id
    params.require(:id)
  end

  def create_params
    params.permit(
      :quotas,
      :average_price,
      :movement_type,
      :date
    )
  end

  def params_time
    @params_time ||= Time.zone.parse(create_params[:date])
  end

  def creation_date
    if Date.current == params_time.to_date
      Time.current
    else
      params_time
    end
  end

  def demo?
    params[:is_demo] == 'true'
  end
end
