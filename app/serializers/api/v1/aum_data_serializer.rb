class Api::V1::AumDataSerializer < Api::V1::BaseSerializer
  # ActiveModel::Serializer.config.adapter = :attributes
  attributes :id, :first_name, :last_name, :rut, :email, :phone
  attribute :aum

  def aum
    aum = { 
      liquid: {clp: 0, usd: 0, eur: 0, uf: 0, mxn: 0, cop: 0, crc: 0},
      pension_fund: {clp: 0, usd: 0, eur: 0, uf: 0, mxn: 0, cop: 0, crc: 0},
      real_estate: {clp: 0, usd: 0, eur: 0, uf: 0, mxn: 0, cop: 0, crc: 0},
      others: {clp: 0, usd: 0, eur: 0, uf: 0, mxn: 0, cop: 0, crc: 0}
    }

    memberships_liquid.map do |membership|
      balance = membership.balance process_date
      aum[:liquid][:clp] += balance[:CLP]
      aum[:liquid][:usd] += balance[:USD]
      aum[:liquid][:eur] += balance[:EUR]
      aum[:liquid][:uf] += balance[:UF]
      aum[:liquid][:mxn] += balance[:MXN]
      aum[:liquid][:cop] += balance[:COP]
      aum[:liquid][:crc] += balance[:CRC]
    end

    memberships_pension_funds.map do |membership|
      balance = membership.balance process_date
      aum[:pension_fund][:clp] += balance[:CLP]
      aum[:pension_fund][:usd] += balance[:USD]
      aum[:pension_fund][:eur] += balance[:EUR]
      aum[:pension_fund][:uf] += balance[:UF]
      aum[:pension_fund][:mxn] += balance[:MXN]
      aum[:pension_fund][:cop] += balance[:COP]
      aum[:pension_fund][:crc] += balance[:CRC]
    end

    memberships_real_estate.map do |membership|
      balance = membership.balance process_date
      aum[:real_estate][:clp] += balance[:CLP]
      aum[:real_estate][:usd] += balance[:USD]
      aum[:real_estate][:eur] += balance[:EUR]
      aum[:real_estate][:uf] += balance[:UF]
      aum[:real_estate][:mxn] += balance[:MXN]
      aum[:real_estate][:cop] += balance[:COP]
      aum[:real_estate][:crc] += balance[:CRC]
    end

    memberships_others.map do |membership|
      balance = membership.balance process_date
      aum[:others][:usd] += balance[:USD]
      aum[:others][:clp] += balance[:CLP]
      aum[:others][:eur] += balance[:EUR]
      aum[:others][:uf] += balance[:UF]
      aum[:others][:mxn] += balance[:MXN]
      aum[:others][:cop] += balance[:COP]
      aum[:others][:crc] += balance[:CRC]
    end

    return aum
  end

  private

  def memberships_liquid
    object.memberships.joins("inner join investment_assets on investment_assets.id = memberships.investment_asset_id").where("investment_assets.asset_type not in (6, 7, 8)").active
  end

  def memberships_pension_funds
    object.memberships.joins("inner join investment_assets on investment_assets.id = memberships.investment_asset_id").where("investment_assets.asset_type in (6)").active
  end

  def memberships_real_estate
    object.memberships.joins("inner join investment_assets on investment_assets.id = memberships.investment_asset_id").where("investment_assets.asset_type in (7)").active
  end

  def memberships_others
    object.memberships.joins("inner join investment_assets on investment_assets.id = memberships.investment_asset_id").where("investment_assets.asset_type in (8)").active
  end

  def process_date
    !defined?(instance_options[:date]).nil? ? instance_options[:date] : nil
  end

end
