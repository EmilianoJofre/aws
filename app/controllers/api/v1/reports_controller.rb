class Api::V1::ReportsController < Api::V1::BaseController
  skip_before_action :authenticate_user!
  before_action :authenticate_users!

  def sub_account_report
    respond_with ReportForSubAccount.for(sub_account: sub_account).to_json
  end

  private
  def sub_account
    @sub_account ||= begin
      sub_account = SubAccount.find(params[:sub_account_id])
      sub_account if authorized(sub_account)
    end
  end

  def authorized(sub_account)
    current_user || current_supervisor || current_adviser || current_relation 
  end

end