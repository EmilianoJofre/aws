require 'roo'

class ProcessCountriesUpdateFile < PowerTypes::Command.new(:file)
  def perform
    @countries = rows.first.keys.drop(1)
    rows.each do |row|
      asset = InvestmentAsset.where("LOWER(asset_id) = ?", row['id']&.to_s.downcase).last
      next if asset.nil?
      asset&.update!(updated_countries(row))
    end
  end

  private

  def rows
    xlsx = Roo::Spreadsheet.open(@file.tempfile.path)
    hash = xlsx.parse(headers: true).drop(1)
    hash.first.key?('id') && hash.first.key?('Equity_Country_Chile_Net') ? hash : []
  end

  def updated_countries(row)
    distribution = {}
    @countries.each do |country|
      distribution[country.to_sym] = row[country].to_f if row[country].to_f > 0
    end

    { 
      countries_distribution: distribution 
    }
  end

end
