class MoneyMovementsController < ApplicationController
  def index
    @is_user = user_signed_in?
    @relation_id = relation.id
    @relation_name = relation.full_name
  end

  private

  def relation
    @relation ||= (
      current_relation || current_user&.relations&.find(params['relation_id'])
    ).decorate
  end
end
