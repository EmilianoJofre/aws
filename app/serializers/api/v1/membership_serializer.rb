class Api::V1::MembershipSerializer < Api::V1::BaseSerializer
  attributes :id, :quotas_balance,
             :amount_invested_balance, :amount_updated_balance, :incomes_balance,
             :quota_average_price, :updated_quota_average_price,
             :alternative_names

  # TODO Refactorizar

  # Real Estate Info
  attribute :others_id, if: :others_membership?
  attribute :real_estate_id, if: :real_estate?
  attribute :name, if: :real_estate_or_liability_or_others_membership?
  attribute :commune, if: :real_estate?
  attribute :role, if: :real_estate?
  attribute :total_inversion, if: :real_estate?
  attribute :cost_m2, if: :real_estate?
  attribute :lat, if: :real_estate?
  attribute :lon, if: :real_estate?
  attribute :location_sql, if: :real_estate?
  attribute :address, if: :real_estate?
  attribute :asset_destination, if: :real_estate?
  attribute :contributions, if: :real_estate?
  attribute :fiscal_appraisal, if: :real_estate?
  attribute :area, if: :real_estate?
  attribute :builded_area, if: :real_estate?
  attribute :year, if: :real_estate?
  attribute :created_at, if: :real_estate?
  attribute :price_changes, if: :real_estate?

  attribute :vl_valorization, if: :real_estate_or_others_membership?
  attribute :vl_valorization, if: :real_estate_or_others_membership?
  attribute :vl_valorization_date, if: :real_estate_or_others_membership?
  attribute :external_valorization, if: :real_estate_or_others_membership?
  attribute :external_valorization_date, if: :real_estate_or_others_membership?
  attribute :external_valorization_name, if: :real_estate_or_others_membership?

  # Liability Info
  attribute :liability_id, if: :liability?
  attribute :description, if: :liability?
  attribute :initial_debt, if: :liability?
  attribute :debt_participation, if: :liability?
  attribute :total_fees, if: :liability?
  attribute :fees_paid, if: :liability?
  attribute :outstanding_balance, if: :liability?
  attribute :start_date, if: :liability?
  attribute :end_date, if: :liability?
  attribute :payment_cycle, if: :liability?
  attribute :next_payment_date, if: :liability?
  attribute :days_to_next_payment_date, if: :liability?
  attribute :rate, if: :liability?
  attribute :rate_description, if: :liability?
  attribute :rate_type, if: :liability?
  attribute :related_investment_asset, if: :liability?

  attribute :investment_asset
  attribute :money_movements, if: :movements?
  attribute :total_inversion, if: :real_estate?

  # OthersMembership Info
  attribute :others_price_changes, if: :others_membership?
  attribute :quantity, if: :others_membership?
  attribute :total_investment, if: :others_membership?

  # InsuranceMembership Info
  attribute :details, if: :insurance?
  attribute :insuree, if: :insurance?
  attribute :beneficiary, if: :insurance?
  attribute :prime, if: :insurance?
  attribute :insured_capital, if: :insurance?
  attribute :insurance_file_id, if: :insurance?
  attribute :policy_end, if: :insurance?
  attribute :policy_renovation, if: :insurance?
  attribute :insurance_file_url, if: :insurance?
  attribute :initial_investment, if: :insurance?

  def amount_updated_balance
    amount = object.updated_balance / DollarPrice.step_business_day if object.currency == 'USD'
    amount = object.updated_balance / EuroPrice.step_business_day if object.currency == 'EUR'
    amount = object.updated_balance / UfPrice.step_business_day if object.currency == 'UF'
    amount = object.updated_balance / MxnPrice.step_business_day if object.currency == 'MXN'
    amount = object.updated_balance / CopPrice.step_business_day if object.currency == 'COP'
    amount = object.updated_balance / CrcPrice.step_business_day if object.currency == 'CRC'
    amount ||= object.updated_balance
    amount
  end

  def name
    name = real_estate_obj&.name if real_estate?
    name = liability_obj&.name if liability?
    name = others_obj&.name if others_membership?
    name = insurance_obj&.name if insurance?
    name
  end

  def quantity
    others_obj&.quantity
  end

  def total_investment
    others_obj&.total_investment
  end

  # Liability Info
  def liability_id
    liability_obj.id
  end

  def description
    liability_obj.description
  end

  def related_investment_asset
    return nil if liability_obj.investment_asset_id.nil?
    Api::V1::InvestmentAssetSerializer.new(InvestmentAsset.find(liability_obj.investment_asset_id))
  end

  def initial_debt
    liability_obj.initial_debt
  end

  def debt_participation
    liability_obj.debt_participation
  end

  def total_fees
    liability_obj.total_fees
  end

  def fees_paid
    liability_obj.fees_paid
  end

  def outstanding_balance
    liability_obj.outstanding_balance
  end

  def start_date
    liability_obj.start_date
  end

  def end_date
    liability_obj.end_date
  end

  def payment_cycle
    liability_obj.payment_cycle
  end

  def next_payment_date
    liability_obj.start_date + (liability_obj.fees_paid.to_i * payment_cycle_in_months.to_i).months
  end

  def days_to_next_payment_date
    (next_payment_date - Date.current).to_i
  end

  def rate
    liability_obj.rate
  end

  def rate_description
    liability_obj.rate_description
  end

  def rate_type
    liability_obj.rate_type
  end

  # Real estate info
  def real_estate_id
    real_estate_obj.id
  end

  def commune
    Commune.find_by_code_sii(real_estate_obj.commune)&.name || nil
  end

  def role
    real_estate_obj.role
  end

  def total_inversion
    real_estate_obj.total_inversion
  end

  def cost_m2
    total_inversion.to_f / area.to_f
  end

  def lat
    real_estate_obj.lat
  end

  def lon
    real_estate_obj.lon
  end

  def location_sql
    real_estate_obj.location_sql
  end

  def address
    real_estate_obj.address
  end

  def asset_destination
    real_estate_obj.asset_destination
  end

  def contributions
    real_estate_obj.contributions
  end

  def fiscal_appraisal
    real_estate_obj.fiscal_appraisal
  end

  def area
    real_estate_obj.area
  end

  def builded_area
    real_estate_obj.builded_area
  end

  def year
    real_estate_obj.year
  end

  def created_at
    real_estate_obj.created_at
  end

  def vl_valorization
    obj = real_estate_obj if real_estate?
    obj = others_obj if others_membership? 
    obj&.vl_valorization
  end

  def external_valorization
    obj = real_estate_obj if real_estate?
    obj = others_obj if others_membership? 
    obj&.external_valorization
  end

  def vl_valorization_date
    obj = real_estate_obj if real_estate?
    obj = others_obj if others_membership?
    obj&.vl_valorization_date
  end

  def external_valorization_date
    obj = real_estate_obj if real_estate?
    obj = others_obj if others_membership? 
    obj&.external_valorization_date
  end

  def external_valorization_name
    obj = real_estate_obj if real_estate?
    obj = others_obj if others_membership? 
    obj&.external_valorization_name
  end
  # Real estate info

  def investment_asset
    Api::V1::InvestmentAssetSerializer.new(object.investment_asset)
  end

  def money_movements
    membership_movements.map do |movement|
      serializer = Api::V1::MoneyMovementSerializer.new(movement)
      puts_association(serializer)
    end
  end

  def real_estate
    Api::V1::RealEstateSerializer.new(real_estate_obj)
  end

  def price_changes
    real_estate_obj.re_value_changes.select('id, total_value as value, valuer, type_valuer, created_at as price_changed_at')
  end

  def membership_movements
    object.money_movements.valid.order('date DESC')
  end

  def movements?
    @instance_options[:movements]
  end

  def real_estate?
    object.asset_type == 'real_estate'
  end
  
  def liability?
    object.asset_type == 'liability'
  end

  def others_membership?
    object.asset_type == 'others'
  end

  def insurance?
    object.asset_type == 'insurance' || object.asset_type == 'investment_insurance' 
  end

  def real_estate_or_liability_or_others_membership?
    real_estate? || liability? || others_membership? || insurance?
  end

  def real_estate_or_others_membership?
    real_estate? || others_membership?
  end

  def alternative_names
    arr = []
    # object.alternative_names.map do |name|
    #   arr.push name.name
    # end
    arr
  end

  def others_price_changes
    others_obj&.value_changes&.select('id, total_value as value, valuer, type_valuer, created_at as price_changed_at')
  end

  # Insurances Info

  def details
    insurance_obj.details
  end

  def insuree
    insurance_obj.insuree
  end

  def beneficiary
    insurance_obj.beneficiary
  end
  
  def prime
    insurance_obj.prime
  end

  def insured_capital
    insurance_obj.insured_capital
  end

  def insurance_file_id
    insurance_obj.insurance_file_id
  end

  def policy_end
    insurance_obj.policy_end&.strftime("%Y-%m-%d")
  end

  def policy_renovation
    insurance_obj.policy_renovation&.strftime("%Y-%m-%d")
  end

  def insurance_file_url
    insurance_obj.insurance_file&.file&.url
  end

  def initial_investment
    insurance_obj.initial_investment
  end
  
  def others_id
    others_obj.id
  end

  private

  def payment_cycle_in_months
    case liability_obj.payment_cycle
    when "monthly"
      return 1
    when "quarterly"
      return 3
    when "biannual"
      return 6
    when "annual"
      return 12
    end
  end

  def real_estate_obj
    RealEstate.find_by(membership_id: object.id)
  end

  def liability_obj
    Liability.find_by(membership_id: object.id)
  end

  def others_obj
    OthersMembership.find_by(membership_id: object.id)
  end

  def insurance_obj
    Insurance.find_by(membership_id: object.id)
  end
end
