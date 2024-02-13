require 'roo'

class ProcessPriceChangesFile < PowerTypes::Command.new(:file)
  def perform
    rows.each do |row|
      next if row['price'].nil?
      row = clean_row row

      asset = InvestmentAsset.where("LOWER(asset_id) = ?", row['id']&.to_s.downcase).last
      next if asset.nil?

      asset&.update!(updated_metrics(row))
      create_price_change(asset, row)
    end
  end

  private

  def clean_row row
    row['price'] = nil if row['price'] == '-N/A'
    row['average annual cost'] = nil if row['average annual cost'] == '-N/A'
    row['mtd'] = nil if row['mtd'] == '-N/A'
    row['recovery level'] = nil if row['recovery level'] == '-N/A'
    row['qtd'] = nil if row['qtd'] == '-N/A'
    row['ytd'] = nil if row['ytd'] == '-N/A'
    row['1y'] = nil if row['1y'] == '-N/A'
    row['3y'] = nil if row['3y'] == '-N/A'
    row['5y'] = nil if row['5y'] == '-N/A'
    row['sub sector'] = nil if row['sub sector'] == '-N/A'
    row
  end

  def rows
    xlsx = Roo::Spreadsheet.open(@file.tempfile.path)
    hash = xlsx.parse(headers: true).drop(1)
    hash.first.key?('id') && hash.first.key?('price') ? hash : []
  end

  def updated_metrics(row)
    {
      mtd: row['mtd'],
      recovery_level: row['recovery level'],
      qtd: row['qtd'],
      ytd: row['ytd'],
      y1: row['1y'],
      y3: row['3y'],
      y5: row['5y'],
      sub_sector: row['sub sector'],
      average_annual_cost: row['average annual cost']
    }
  end

  def create_price_change(asset, row)
    if asset&.last_price_change&.value&.to_f != row['price'].to_f
      PriceChange.create(
        price_changed_at: Time.current - 1.day,
        investment_asset_id: asset.id,
        value: row['price'],
        from_file: true
      )
    end
  end
end
