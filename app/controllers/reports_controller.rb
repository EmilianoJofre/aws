class ReportsController < ApplicationController
  def index
    @is_user = user_signed_in?
    redirect_to root_path unless relation
  end

  def relation
    @relation ||= current_relation || current_user&.relations&.find(params['relation_id'])
  end
end
