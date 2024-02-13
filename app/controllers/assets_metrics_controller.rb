class AssetsMetricsController < ApplicationController
  def index
    @assets = investment_assets
    @relation_id = relation.id
    @dollar = DollarPrice.step_business_day
    @euro = EuroPrice.step_business_day
    @uf = UfPrice.step_business_day
    @mxn = MxnPrice.step_business_day
    @cop = CopPrice.step_business_day
    @crc = CrcPrice.step_business_day
  end

  private

  def relation
    @relation ||= current_relation || current_user&.relations&.find(params['relation_id'])
  end

  def investment_assets
    relation.investment_assets.not_custom.includes(
      :memberships
    ).where(memberships: { hidden: false }).distinct
  end
end
