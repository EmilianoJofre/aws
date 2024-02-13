# rubocop:disable Layout/LineLength
class RelationsController < ApplicationController
  before_action :user?

  def show
    @relation = relation
    @is_demo = demo?
    @assets = investment_assets
    @accounts = relation_accounts
    @accountsInvestmentInstruments = relation_accounts_investment_instruments
    @accountsPensionFunds = relation_accounts_pension_funds
    @accountsRealEstate = relation_accounts_real_estates
    @first_name = @relation.first_name
    @last_name = last_name
    @dollar = DollarPrice.step_business_day
    @euro = EuroPrice.step_business_day
    @uf = UfPrice.step_business_day
    @mxn = MxnPrice.step_business_day
    @cop = CopPrice.step_business_day
    @crc = CrcPrice.step_business_day
    @is_user = current_user.present?
    @last_updated = last_price_change
    @next_chart_update = next_chart_update
    @internal_id = current_user.present? ? current_user.internal_id : @relation.internal_id
  end
  
  def initialAndLastname
    "#{first_name[0]}. #{last_name}"
  end

  def get_xls
    # chart_file = Rails.root.join('public/xls/' + rel.id.to_s + '_chart.png')
    if params['summary']
      rel = Relation.find(params['relation_id'])
      xls_file = Rails.root.join('public/xls/' + rel.id.to_s + '_resume.xls')
      Relation.create_summary_xls rel, params, xls_file
    else
      rel = relation params['relation_id']
      xls_file = Rails.root.join('public/xls/' + rel.id.to_s + '_resume.xls')
      Relation.create_xls rel, params, xls_file 
    end

    respond_to do |format|
      format.any do
        send_file xls_file, :x_sendfile=>true
      end
    end    
  end

  def get_pdf
    
    rel = relation params['relation_id']

    pdf_file = Rails.root.join('public/pdfs/' + rel.id.to_s + '_resume.pdf')
    chart_file = Rails.root.join('public/pdfs/' + rel.id.to_s + '_chart.png')

    # Create chart
    Relation.create_chart_image rel, params, chart_file

    # Create PDF
    Relation.create_pdf rel, params, chart_file, pdf_file

    respond_to do |format|
      format.any do
        send_file pdf_file, :x_sendfile=>true
      end
    end

  end

  private

  def relation id = nil
    id = id.nil? ? params['id'] : id
    return current_relation if !current_relation.nil?

    demo? ? DemoRelation.find(id) : Relation.find(id)
  end

  def user?
    redirect_to root_path unless current_user.present? || current_relation.present? || current_supervisor.present? || current_adviser.present?
  end

  def demo?
    params[:demo] == 'true'
  end

  def last_name
    @is_demo ? Faker::Name.last_name : @relation.last_name
  end

  def last_price_change
    PriceChange.from_file.last&.price_changed_at
  end

  def next_chart_update
    @next_chart_update ||= CronUtils.next_ocurrence('update_charts')
  end

  def investment_assets
    @relation.investment_assets.joins(
      :memberships
    ).where(memberships: { hidden: false }).distinct
  end

  def relation_accounts
    demo? ? @relation.demo_relation_accounts.includes(:bank) : @relation.relation_accounts.includes(:bank)
  end

  def relation_accounts_investment_instruments
    demo? ? @relation.demo_relation_accounts.joins(:sub_accounts).joins(:memberships).joins("inner join investment_assets on investment_assets.id = memberships.investment_asset_id").where("investment_assets.asset_type IN (6)").distinct.includes(:bank) : @relation.relation_accounts.joins(:sub_accounts).joins(:memberships).joins("inner join investment_assets on investment_assets.id = memberships.investment_asset_id").where("investment_assets.asset_type IN (0,1,2,3,4,5)").distinct.includes(:bank)
  end

  def relation_accounts_pension_funds
    demo? ? @relation.demo_relation_accounts.joins(:sub_accounts).joins(:memberships).joins("inner join investment_assets on investment_assets.id = memberships.investment_asset_id").where("investment_assets.asset_type IN (6)").distinct.includes(:bank) : @relation.relation_accounts.joins(:sub_accounts).joins(:memberships).joins("inner join investment_assets on investment_assets.id = memberships.investment_asset_id").where("investment_assets.asset_type IN (6)").distinct.includes(:bank)
  end

  def relation_accounts_real_estates
    demo? ? @relation.demo_relation_accounts.joins(:sub_accounts).joins(:memberships).joins("inner join investment_assets on investment_assets.id = memberships.investment_asset_id").where("investment_assets.asset_type IN (7)").distinct.includes(:bank) : @relation.relation_accounts.joins(:sub_accounts).joins(:memberships).joins("inner join investment_assets on investment_assets.id = memberships.investment_asset_id").where("investment_assets.asset_type IN (7)").distinct.includes(:bank)
  end
end
# rubocop:enable Layout/LineLength
