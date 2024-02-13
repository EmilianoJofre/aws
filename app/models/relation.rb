# rubocop:disable Rails/RedundantForeignKey
class Relation < ApplicationRecord
  include LedgerizerAccountable
  include WalletConcern
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  acts_as_token_authenticatable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable,
  :jwt_authenticatable,
  jwt_revocation_strategy: JwtDenylist
  extend Enumerize
  belongs_to :user
  has_many :relation_accounts, class_name: "::Account", dependent: :destroy, inverse_of: :relation
  has_many :sub_accounts, through: :relation_accounts
  has_many :memberships, through: :sub_accounts
  has_many :money_movements, through: :memberships
  has_many :investment_assets, through: :memberships
  has_many :relation_histories, dependent: :destroy
  has_many :relation_files, dependent: :destroy

  has_many :adviser_relations
  has_many :advisers, through: :adviser_relations 
  accepts_nested_attributes_for :advisers

  has_many :demo_relation_accounts,
           class_name: "::DemoAccount",
           inverse_of: :relation, foreign_key: :relation_id, dependent: :destroy

  validates :first_name, :last_name, :rut, presence: true

  before_save :update_balance, if: :will_save_change_to_updated_balance?

  def config_vars
    data = self.vars.blank? ? '[]' : self.vars
    JSON.parse(data)
  end

  def update_balance
    self.update_columns(updated_balance: self.balance)
  end

  def balance
    positive_balance = relation_accounts.where.not(account_type: "liability").pluck(:updated_balance).compact.reduce(:+)
    negative_balance = relation_accounts.where(account_type: "liability").pluck(:updated_balance).compact.reduce(:+)
    positive_balance.to_f - negative_balance.to_f
  end

  def internal_id
    "VL-#{rut_number}"
  end

  def initials
    "#{first_name[0]}#{last_name[0]}"
  end
  
  def initialAndLastname
    "#{first_name[0]}. #{last_name}"
  end

  def name
    "#{first_name} #{last_name}"
  end

  def type
    'investor'
  end
  
  def self.create_xls rel, params, xls_file
    require 'axlsx'


    dollar = DollarPrice.step_business_day
    euro = EuroPrice.step_business_day
    uf = UfPrice.step_business_day
    mxn = MxnPrice.step_business_day
    cop = CopPrice.step_business_day
    crc = CrcPrice.step_business_day

    accounts = Account.find params[:ids]
    accounts_names = accounts.collect(&:name).join(', ')
    assetvalue = params[:assetvalue]

    investments = rel.relation_accounts.where(id: params[:ids])

    p = Axlsx::Package.new
    wb = p.workbook

    # Default style
    wb.styles.add_style font_name: 'Calibri', fg_color: '333333', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }

    # Styles
    s = wb.styles
    default_style = s.add_style font_name: 'Calibri', fg_color: '333333', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }
    default_date_style = s.add_style font_name: 'Calibri', :format_code => 'yyyy-mm-dd', fg_color: '333333', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }
    header_style = s.add_style font_name: 'Calibri', bg_color: 'EAEAFF', fg_color: '4F52FF', sz: 11, alignment: { horizontal: :center }, border: { style: :thin, color: '000000' }
    red_value = s.add_style font_name: 'Calibri', fg_color: 'fc4347', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }
    green_value = s.add_style font_name: 'Calibri', fg_color: '62a838', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }
    default_one_decimal = s.add_style format_code: '#,##0.0', font_name: 'Calibri', fg_color: '333333', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }

    default_percent_decimals = s.add_style format_code: '0.00%', font_name: 'Calibri', fg_color: '333333', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }

    # Currencies con decimal
    default_usd_one_decimal = s.add_style format_code: 'USD$#,##0.0_)', font_name: 'Calibri', fg_color: '333333', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }
    default_clp_one_decimal = s.add_style format_code: 'CLP$#,##0.0_)', font_name: 'Calibri', fg_color: '333333', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }
    default_eur_one_decimal = s.add_style format_code: 'EUR$#,##0.0_)', font_name: 'Calibri', fg_color: '333333', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }
    default_uf_one_decimal = s.add_style format_code: 'UF$#,##0.0_)', font_name: 'Calibri', fg_color: '333333', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }
    default_mxn_one_decimal = s.add_style format_code: 'MXN$#,##0.0_)', font_name: 'Calibri', fg_color: '333333', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }
    default_cop_one_decimal = s.add_style format_code: 'COP$#,##0.0_)', font_name: 'Calibri', fg_color: '333333', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }
    default_crc_one_decimal = s.add_style format_code: 'CRC$#,##0.0_)', font_name: 'Calibri', fg_color: '333333', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }

    # Currencies sin decimal
    default_usd = s.add_style format_code: 'USD$#,##0_)', font_name: 'Calibri', fg_color: '333333', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }
    default_clp = s.add_style format_code: 'CLP$#,##0_)', font_name: 'Calibri', fg_color: '333333', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }
    default_eur = s.add_style format_code: 'EUR$#,##0_)', font_name: 'Calibri', fg_color: '333333', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }
    default_uf = s.add_style format_code: 'UF$#,##0_)', font_name: 'Calibri', fg_color: '333333', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }
    default_mxn = s.add_style format_code: 'MXN$#,##0_)', font_name: 'Calibri', fg_color: '333333', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }
    default_cop = s.add_style format_code: 'COP$#,##0_)', font_name: 'Calibri', fg_color: '333333', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }
    default_crc = s.add_style format_code: 'CRC$#,##0_)', font_name: 'Calibri', fg_color: '333333', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }

    # Currencies sin decimal rojo
    red_usd = s.add_style format_code: 'USD$#,##0_)', font_name: 'Calibri', fg_color: 'fc4347', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }
    red_clp = s.add_style format_code: 'CLP$#,##0_)', font_name: 'Calibri', fg_color: 'fc4347', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }
    red_eur = s.add_style format_code: 'EUR$#,##0_)', font_name: 'Calibri', fg_color: 'fc4347', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }
    red_uf = s.add_style format_code: 'UF$#,##0_)', font_name: 'Calibri', fg_color: 'fc4347', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }
    red_mxn = s.add_style format_code: 'MXN$#,##0_)', font_name: 'Calibri', fg_color: 'fc4347', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }
    red_cop = s.add_style format_code: 'COP$#,##0_)', font_name: 'Calibri', fg_color: 'fc4347', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }
    red_crc = s.add_style format_code: 'CRC$#,##0_)', font_name: 'Calibri', fg_color: 'fc4347', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }

    # Currencies sin decimal verde
    green_usd = s.add_style format_code: 'USD$#,##0_)', font_name: 'Calibri', fg_color: '62a838', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }
    green_clp = s.add_style format_code: 'CLP$#,##0_)', font_name: 'Calibri', fg_color: '62a838', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }
    green_eur = s.add_style format_code: 'EUR$#,##0_)', font_name: 'Calibri', fg_color: '62a838', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }
    green_uf = s.add_style format_code: 'UF$#,##0_)', font_name: 'Calibri', fg_color: '62a838', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }
    green_mxn = s.add_style format_code: 'MXN$#,##0_)', font_name: 'Calibri', fg_color: '62a838', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }
    green_cop = s.add_style format_code: 'COP$#,##0_)', font_name: 'Calibri', fg_color: '62a838', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }
    green_crc = s.add_style format_code: 'CRC$#,##0_)', font_name: 'Calibri', fg_color: '62a838', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }

    # Porcentajes con decimal rojo
    red_percent = s.add_style format_code: '0.00%', font_name: 'Calibri', fg_color: 'fc4347', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }

    # Porcentajes con decimal verde
    green_percent = s.add_style format_code: '0.00%', font_name: 'Calibri', fg_color: '62a838', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }

    total_xls_etf_patrimony = 0
    accounts = Account.find params[:ids]
    accounts.each do |account|
      account.sub_accounts.each do |sub_account|
        sub_account_etf_patrimony = sub_account.memberships.sum { |membership| membership.accounts.find_by(name: 'amount_updated')&.balance.to_f }
        case sub_account.currency
        when 'USD'
          total_xls_etf_patrimony += sub_account_etf_patrimony
        when 'CLP'
          total_xls_etf_patrimony += (sub_account_etf_patrimony / dollar)
        when 'UF'
          total_xls_etf_patrimony += ((sub_account_etf_patrimony * uf) / dollar)
        when 'EUR'
          total_xls_etf_patrimony += ((sub_account_etf_patrimony * euro) / dollar)
        when 'MXN'
          total_xls_etf_patrimony += ((sub_account_etf_patrimony * mxn) / dollar)
        when 'COP'
          total_xls_etf_patrimony += ((sub_account_etf_patrimony * cop) / dollar)
        when 'CRC'
          total_xls_etf_patrimony += ((sub_account_etf_patrimony * crc) / dollar)
        end
      end
    end

    # Header
    wb.add_worksheet(name: 'Inversiones') do |sheet|
      
      # Header Investments
      sheet.add_row ['Cuenta', 'Banco', 'Sub Cuenta', 'Moneda', 'Instrumento', 'Nombre', 'Tipo de activo', 'Cantidad', 'Costo', 'Inversión Total', 'Precio Cierre', 'Monto actual', 'Plusvalia', 'Rentabilidad', 'Peso'], style: [header_style] * 15 if assetvalue == 'investment'
      # Header Pension Funds
      sheet.add_row ['Cuenta', 'Banco', 'Sub Cuenta', 'Moneda', 'Instrumento', 'Nombre', 'Tipo de activo', 'Cantidad', 'Costo', 'Inversión Total', 'Precio Cierre', 'Monto actual', 'Plusvalia', 'Rentabilidad', 'Peso'], style: [header_style] * 15 if assetvalue == 'pension_fund'
      # Header Real Estate
      sheet.add_row ['Cuenta', 'Banco', 'Sub Cuenta', 'Moneda', 'Nombre', 'Rol', 'Destino del activo', 'Comuna', 'Cantidad m2', 'Costo m2', 'Inversión total', 'Avalúo fiscal', 'Valorización Valuelist', 'Valorizacion externa', 'Plusvalia', 'Rentabilidad', 'Peso'], style: [header_style] * 19 if assetvalue == 'real_estate'
      # Header Liabilities
      sheet.add_row ['Cuenta', 'Banco', 'Sub Cuenta', 'Moneda', 'Nombre', 'Activo asociado', 'Deuda inicial', 'Porc. de participación', 'Fecha inicio', 'Fecha venc.', 'Tasa', 'Desc. tasa', 'Periodicidad pago', 'Proximo pago', 'Saldo insoluto', 'Peso'], style: [header_style] * 16 if assetvalue == 'liability'
      # Header Others
      sheet.add_row ['Cuenta', 'Banco', 'Sub Cuenta', 'Moneda', 'Nombre', 'Cantidad', 'Inversión total', 'Valorización Valuelist', 'Valorizacion externa', 'Plusvalia', 'Rentabilidad', 'Peso'], style: [header_style] * 12 if assetvalue == 'others'
      
      accounts = Account.find params[:ids]
      accounts.each do |account|
        account.sub_accounts.each do |sub_account|
                    
          total_etf_patrimony = sub_account.memberships.sum { |membership| membership.accounts.find_by(name: 'amount_updated')&.balance.to_f }
          
          sub_account.memberships.each do |membership|

            if !membership.hidden then

              # Calculos
              etf_dollar = 0
              etf_patrimony = membership.accounts.find_by(name: 'amount_updated')&.balance.to_f

              case sub_account.currency
              when 'USD'
                etf_dollar = etf_patrimony
              when 'CLP'
                etf_dollar = (etf_patrimony / dollar)
              when 'UF'
                etf_dollar = ((etf_patrimony * uf) / dollar)
              when 'EUR'
                etf_dollar = ((etf_patrimony * euro) / dollar)
              when 'MXN'
                etf_dollar = ((etf_patrimony * mxn) / dollar)
              when 'COP'
                etf_dollar = ((etf_patrimony * cop) / dollar)
              when 'CRC'
                etf_dollar = ((etf_patrimony * crc) / dollar)
              end

              rentabilidad = (membership.incomes_balance.to_f / membership.amount_invested_balance.to_f) * 100
              pr = (etf_dollar * 100) / total_xls_etf_patrimony

              value_style = membership.incomes_balance.to_i > 0 ? green_value : red_value
              value_style = default_style if membership.incomes_balance.to_i == 0

              # Nombre de instrumentos
              instrumento = membership.investment_asset.asset_id
              instrumento = membership.investment_asset.name if membership.investment_asset.asset_id.include? 'custom_'

              # Currency formats
              actual_currency = sub_account.currency.upcase
              cell_currency_format = default_style
              cell_currency_format = default_usd if actual_currency == 'USD'
              cell_currency_format = default_clp if actual_currency == 'CLP'
              cell_currency_format = default_eur if actual_currency == 'EUR'
              cell_currency_format = default_uf if actual_currency == 'UF'
              cell_currency_format = default_mxn if actual_currency == 'MXN'
              cell_currency_format = default_cop if actual_currency == 'COP'
              cell_currency_format = default_crc if actual_currency == 'CRC'
              cell_currency_format_one_decimal = default_style
              cell_currency_format_one_decimal = default_usd_one_decimal if actual_currency == 'USD'
              cell_currency_format_one_decimal = default_clp_one_decimal if actual_currency == 'CLP'
              cell_currency_format_one_decimal = default_eur_one_decimal if actual_currency == 'EUR'
              cell_currency_format_one_decimal = default_uf_one_decimal if actual_currency == 'UF'
              cell_currency_format_one_decimal = default_mxn_one_decimal if actual_currency == 'MXN'
              cell_currency_format_one_decimal = default_cop_one_decimal if actual_currency == 'COP'
              cell_currency_format_one_decimal = default_crc_one_decimal if actual_currency == 'CRC'

              cell_currency_format_color = cell_currency_format
              cell_percent_format_color = default_percent_decimals
              if membership.incomes_balance.to_i > 0 then
                cell_percent_format_color = green_percent
                cell_currency_format_color = green_usd if actual_currency == 'USD'
                cell_currency_format_color = green_clp if actual_currency == 'CLP'
                cell_currency_format_color = green_eur if actual_currency == 'EUR'
                cell_currency_format_color = green_uf if actual_currency == 'UF'
                cell_currency_format_color = green_mxn if actual_currency == 'MXN'
                cell_currency_format_color = green_cop if actual_currency == 'COP'
                cell_currency_format_color = green_crc if actual_currency == 'CRC'
              elsif membership.incomes_balance.to_i < 0 then
                cell_percent_format_color = red_percent
                cell_currency_format_color = red_usd if actual_currency == 'USD'
                cell_currency_format_color = red_clp if actual_currency == 'CLP'
                cell_currency_format_color = red_eur if actual_currency == 'EUR'
                cell_currency_format_color = red_uf if actual_currency == 'UF'
                cell_currency_format_color = red_mxn if actual_currency == 'MXN'
                cell_currency_format_color = red_cop if actual_currency == 'COP'
                cell_currency_format_color = red_crc if actual_currency == 'CRC'
              end
              
              # Row

              # Row Investment
              sheet.add_row [
                account.name, 
                account.bank.name, 
                sub_account.sub_account_id,
                sub_account.currency,
                instrumento, # Instrumento
                membership.investment_asset.name, # Nombre
                I18n.t(
                  "activerecord.attributes.investment_assets.asset_type.#{membership.investment_asset.asset_type}"
                ), # Tipo de Activo
                membership.quotas_balance, # Cantidad
                membership.quota_average_price, # Costo
                membership.amount_invested_balance, # Inversion total
                membership.updated_quota_average_price,  # Precio cierre
                membership.amount_updated_balance, # Monto Actual
                membership.incomes_balance ? membership.incomes_balance : 0, # Plusvalia
                rentabilidad / 100, # Rentabilidad
                pr.to_f / 100
              ], style: [
                default_style,
                default_style,
                default_style,
                default_style,
                default_style,
                default_style,
                default_style,
                default_one_decimal,
                cell_currency_format_one_decimal,
                cell_currency_format,
                cell_currency_format_one_decimal,
                cell_currency_format,
                cell_currency_format_color,
                cell_percent_format_color,
                default_percent_decimals,
              ] if assetvalue == 'investment'

              # Row Pension Funds
              sheet.add_row [
                account.name, 
                account.bank.name, 
                sub_account.sub_account_id,
                sub_account.currency,
                instrumento, # Instrumento
                membership.investment_asset.name, # Nombre
                I18n.t(
                  "activerecord.attributes.investment_assets.asset_type.#{membership.investment_asset.asset_type}"
                ), # Tipo de Activo
                membership.quotas_balance, # Cantidad
                membership.quota_average_price, # Costo
                membership.amount_invested_balance, # Inversion total
                membership.updated_quota_average_price,  # Precio cierre
                membership.amount_updated_balance, # Monto Actual
                membership.incomes_balance ? membership.incomes_balance : 0, # Plusvalia
                rentabilidad / 100, # Rentabilidad
                pr.to_f / 100
              ], style: [
                default_style,
                default_style,
                default_style,
                default_style,
                default_style,
                default_style,
                default_style,
                default_one_decimal,
                cell_currency_format_one_decimal,
                cell_currency_format,
                cell_currency_format_one_decimal,
                cell_currency_format,
                cell_currency_format_color,
                cell_percent_format_color,
                default_percent_decimals,
              ] if assetvalue == 'pension_fund'
              
              # Row Real Estate
              if assetvalue == 'real_estate' then

                internal_value = membership.real_estates[0].re_value_changes.internal.empty? ? '' : membership.real_estates[0].re_value_changes.internal.last.total_value
                external_value = membership.real_estates[0].re_value_changes.external.empty? ? '' : membership.real_estates[0].re_value_changes.external.last.total_value
                area_value = membership.real_estates[0].re_value_changes.empty? ? '' : membership.real_estates[0].re_value_changes.last.area_value

                sheet.add_row [
                  account.name, 
                  account.bank.name, 
                  sub_account.sub_account_id,
                  sub_account.currency,
                  membership.investment_asset.name, # Nombre
                  membership.real_estates[0].role,
                  membership.real_estates[0].asset_destination,
                  Commune.find_by_code_sii(membership.real_estates[0].commune).name,
                  membership.real_estates[0].area,
                  area_value,
                  membership.real_estates[0].total_inversion,
                  membership.real_estates[0].fiscal_appraisal,
                  internal_value, # Valorizacion VL
                  external_value, # Valorizacion Externa
                  membership.incomes_balance ? membership.incomes_balance : 0, # Plusvalia
                  rentabilidad / 100, # Rentabilidad
                  pr.to_f / 100
                ], style: [
                  default_style,
                  default_style,
                  default_style,
                  default_style,
                  default_style,
                  default_style,
                  default_style,
                  default_style,
                  default_style,
                  cell_currency_format,
                  cell_currency_format,
                  cell_currency_format_one_decimal,
                  cell_currency_format_one_decimal,
                  cell_currency_format_one_decimal,
                  cell_currency_format,
                  cell_percent_format_color,
                  default_percent_decimals,
                ]
              end
              
              # Row Liabilities
              if assetvalue == 'liability' then
                related_investment_asset = membership.liabilities[0].investment_asset_id.nil? ? '' : membership.liabilities[0].investment_asset.name
                sheet.add_row [
                  account.name, 
                  account.bank.name, 
                  sub_account.sub_account_id,
                  sub_account.currency,
                  membership.liabilities[0].name,
                  related_investment_asset,
                  membership.liabilities[0].initial_debt,
                  membership.liabilities[0].debt_participation * 0.01,
                  membership.liabilities[0].start_date,
                  membership.liabilities[0].end_date,
                  membership.liabilities[0].rate,
                  membership.liabilities[0].rate_description,
                  I18n.t("activerecord.attributes.liability.payment_cycle.#{membership.liabilities[0].payment_cycle}"),
                  membership.liabilities[0].next_payment_date,
                  membership.liabilities[0].outstanding_balance,
                  pr.to_f / 100
                ], style: [
                  default_style,
                  default_style,
                  default_style,
                  default_style,
                  default_style,
                  default_style,
                  cell_currency_format,
                  default_percent_decimals,
                  default_date_style,
                  default_date_style,
                  default_percent_decimals,
                  default_style,
                  default_style,
                  default_date_style,
                  cell_currency_format,
                  default_percent_decimals,
                ]
              end

              # Row Others
              sheet.add_row [
                account.name, 
                account.bank.name, 
                sub_account.sub_account_id,
                sub_account.currency,
                membership.investment_asset.name, # Nombre
                membership.quotas_balance, # Cantidad
                membership.amount_invested_balance, # Inversion total
                membership.others_memberships&.last&.vl_valorization,  # Valorización Valuelist
                membership.others_memberships&.last&.external_valorization,  # Valorización Externa
                membership.incomes_balance ? membership.incomes_balance : 0, # Plusvalia
                rentabilidad / 100, # Rentabilidad
                pr.to_f / 100
              ] if assetvalue == 'others'
              # Fix specific cell values after add
              sheet.rows.last.tap do |row|
                row.cells[13].value = '' if row.cells[13] && row.cells[13].value == 'NaN'
                row.cells[13].value = '' if row.cells[13] && row.cells[13].value == '-Infinity'
              end

            end

          end
        end
      end

      sheet.auto_filter = 'A1:G1'
      
    end

    p.serialize xls_file
  end

  def self.create_summary_xls rel, params, xls_file
    require 'axlsx'

    p = Axlsx::Package.new
    wb = p.workbook
    currency = params['currency']

    # Default style
    s = wb.styles
    wb.styles.add_style font_name: 'Calibri', fg_color: '333333', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }
    first_row = s.add_style font_name: 'Calibri', fg_color: '111111', bg_color: 'd9d9d9', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }, b: true
    last_row = s.add_style font_name: 'Calibri', fg_color: '111111', bg_color: 'FFFFFF', sz: 10, alignment: { horizontal: :left }, border: { style: :thin, color: '000000' }, b: true
    

    chart_history = SelectedAccountsBalanceJob.perform_now(rel, rel.relation_accounts.pluck(:id), params[:window], true)
    chart_balances = JSON.parse(chart_history.balances_values)
    dates = chart_balances.keys.reverse
    investment_balances = sort_chart_balances(type: 'investment', currency: currency, dates: dates, balances: chart_balances)
    pension_fund_balances = sort_chart_balances(type: 'pension_fund', currency: currency, dates: dates, balances: chart_balances)
    real_estate_balances = sort_chart_balances(type: 'real_estate', currency: currency, dates: dates, balances: chart_balances)
    liability_balances = sort_chart_balances(type: 'liability', currency: currency, dates: dates, balances: chart_balances)
    others_balances = sort_chart_balances(type: 'others', currency: currency, dates: dates, balances: chart_balances)
    total_balances = sort_chart_balances(type: currency, dates: dates, balances: chart_balances)

    excel_dates = [currency]
    dates.each do |date|
      excel_dates << date.split('-').reverse.join('/')
    end

    wb.add_worksheet(name: 'Total Patrimono') do |sheet|
      sheet.add_row excel_dates, style: first_row
      sheet.add_row investment_balances[:state].prepend 'Inversiones'
      sheet.add_row pension_fund_balances[:state].prepend 'Fondos de Pensión'
      sheet.add_row real_estate_balances[:state].prepend 'Bienes Raices'
      sheet.add_row others_balances[:state].prepend 'Otros Bienes'
      sheet.add_row liability_balances[:state].prepend 'Pasivos'
      sheet.add_row (total_balances[:state].prepend 'Patrimonio Total').to_a, style: last_row
    end
    wb.add_worksheet(name: 'Rentabilidad') do |sheet|
      sheet.add_row excel_dates.drop(1).prepend(''), style: first_row
      sheet.add_row investment_balances[:profitability].prepend 'Inversiones'
      sheet.add_row pension_fund_balances[:profitability].prepend 'Fondos de Pensión'
      sheet.add_row real_estate_balances[:profitability].prepend 'Bienes Raices'
      sheet.add_row others_balances[:profitability].prepend 'Otros Bienes'
      sheet.add_row (total_balances[:profitability].prepend 'Patrimonio Total').to_a, style: last_row
    end
    wb.add_worksheet(name: 'Tipo de Activo') do |sheet|
      balances = rel.investments_distribution
      sheet.add_row ['Tipo de Activo', 'Monto', 'Porcentaje'], style: first_row
      sheet.add_row ['Renta Fija', "$#{balances[:fixed_income][currency.to_sym]}",  "#{(balances[:fixed_income][currency.to_sym] * 100 / balances[:total]).to_f.round(2)}%"] if balances[:fixed_income]
      sheet.add_row ['Renta Variable', "$#{balances[:variable_income][currency.to_sym]}",  "#{(balances[:variable_income][currency.to_sym] * 100 / balances[:total]).to_f.round(2)}%"] if balances[:variable_income]
      sheet.add_row ['Money Market', "$#{balances[:money_market][currency.to_sym]}",  "#{(balances[:money_market][currency.to_sym] * 100 / balances[:total]).to_f.round(2)}%"] if balances[:money_market]
      sheet.add_row ['Activos Alternativos', "$#{balances[:alternative_asset][currency.to_sym]}",  "#{(balances[:alternative_asset][currency.to_sym] * 100 / balances[:total]).to_f.round(2)}%"] if balances[:alternative_asset]
      sheet.add_row ['Total', "$#{balances[:total]}", '100%'], style: last_row
    end
    wb.add_worksheet(name: 'Moneda') do |sheet|
      balances = rel.balance_by_currency
      total = rel.updated_balance
      total = total / DollarPrice.step_business_day if currency == 'USD'
      total = total / EuroPrice.step_business_day if currency == 'EUR'
      total = total / UfPrice.step_business_day if currency == 'UF'
      total = total / MxnPrice.step_business_day if currency == 'MXN'
      total = total / CopPrice.step_business_day if currency == 'COP'
      total = total / CrcPrice.step_business_day if currency == 'CRC'
      sheet.add_row ['Moneda', 'Monto', 'Porcentaje'], style: first_row
      sheet.add_row ['CLP', "$#{balances[:CLP][currency.to_sym]}", "#{(balances[:CLP][currency.to_sym] / total * 100).to_f.round(2)}%"]
      sheet.add_row ['EUR', "$#{balances[:EUR][currency.to_sym]}", "#{(balances[:EUR][currency.to_sym] / total * 100).to_f.round(2)}%"]
      sheet.add_row ['USD', "$#{balances[:USD][currency.to_sym]}", "#{(balances[:USD][currency.to_sym] / total * 100).to_f.round(2)}%"]
      sheet.add_row ['UF', "$#{balances[:UF][currency.to_sym]}", "#{(balances[:UF][currency.to_sym] / total * 100).to_f.round(2)}%"]
      sheet.add_row ['MXN', "$#{balances[:MXN][currency.to_sym]}", "#{(balances[:MXN][currency.to_sym] / total * 100).to_f.round(2)}%"]
      sheet.add_row ['COP', "$#{balances[:COP][currency.to_sym]}", "#{(balances[:COP][currency.to_sym] / total * 100).to_f.round(2)}%"]
      sheet.add_row ['CRC', "$#{balances[:CRC][currency.to_sym]}", "#{(balances[:CRC][currency.to_sym] / total * 100).to_f.round(2)}%"]
      sheet.add_row ['Total', "$#{total}", '100%'], style: last_row
    end
    wb.add_worksheet(name: 'Países') do |sheet|
      balances = rel.balance_by_country_2
      countries = []
      balances.each do |continent|
        continent.each do |country|
          next if country.instance_of?(String)
          countries << country
        end
      end
      sheet.add_row ['País', 'Activos', 'Pasivos', 'Patrimonio Total'], style: first_row
      total_assets = 0
      total_liabilities = 0
      countries.each do |country|
        name = country.keys.first
        assets = country[name][:assets].to_f.round(2)
        assets = assets / DollarPrice.step_business_day if currency == 'USD'
        assets = assets / EuroPrice.step_business_day if currency == 'EUR'
        assets = assets / UfPrice.step_business_day if currency == 'UF'
        assets = assets / MxnPrice.step_business_day if currency == 'MXN'
        assets = assets / CopPrice.step_business_day if currency == 'COP'
        assets = assets / CrcPrice.step_business_day if currency == 'CRC'
        liabilities = country[name][:liabilities].to_f.round(2)
        liabilities = liabilities / DollarPrice.step_business_day if currency == 'USD'
        liabilities = liabilities / EuroPrice.step_business_day if currency == 'EUR'
        liabilities = liabilities / UfPrice.step_business_day if currency == 'UF'
        liabilities = liabilities / MxnPrice.step_business_day if currency == 'MXN'
        liabilities = liabilities / CopPrice.step_business_day if currency == 'COP'
        liabilities = liabilities / CrcPrice.step_business_day if currency == 'CRC'
        sheet.add_row [name, "$#{assets}", "$#{liabilities}", "$#{assets - liabilities}"]
        total_liabilities += liabilities
        total_assets += assets
      end
      sheet.add_row ['Total', "$#{total_assets}", "$#{total_liabilities}", "$#{total_assets - total_liabilities}"], style: last_row
    end

    p.serialize xls_file
  end

  def self.create_chart_image rel, params, chart_file

    balances = JSON.parse SelectedAccountsBalanceJob.perform_now(rel, params[:ids], params[:window]).balances_values
  
    # Marks
    balances = Hash[balances.to_a.reverse]
    chart_marker_counts = 6
    marks = []
    for i in 1..chart_marker_counts do marks.push(balances.count / chart_marker_counts * i) end
    
    # Create values and keys
    i = 0
    values = []
    labels = { 0 => balances.first[0] }
    balances.each do |key, balance|
      if marks.include? i then
        labels[i] = key
      end
      values.push balance['selected']['balance'][params[:currency].upcase]
      i = i + 1
    end
  
    min_value = values.map { |d| d }.min.round
    max_value = values.map { |d| d }.max.round

    min_value_delta = min_value - min_value * 0.05
    max_value_delta = max_value + max_value * 0.05

    if params[:currency].upcase == 'UF' then
      min_value = (min_value - min_value * 10 / 100).round
      max_value = (max_value + max_value * 10 / 100).round
    end

    # Chart creation
    g = Gruff::Line.new('1200x500') # Defaults to 800px wide, no lines (for backwards compatibility)
    g.font = Rails.root.join("app/assets/fonts/Poppins/Poppins-Medium.ttf").to_s
    g.theme = {
      colors: %w[black grey],
      marker_color: 'grey',
      font_color: '#515151',
      background_colors: ['#FFFFFF', '#FFFFFF'],
      background_direction: :top_bottom
    }
    g.labels = labels
    g.data 'Values', values
  
    g.y_axis_label_format = lambda do |value|
      if params[:currency].upcase == "USD" then
        "#{ActionController::Base.helpers.number_to_currency(value.to_i, :locale => :en, :precision => 0)}"
      elsif params[:currency].upcase == "EUR" then
        "#{ActionController::Base.helpers.number_to_currency(value.to_i, format: "%n %u", unit: "€", :precision => 0)}"
      elsif params[:currency].upcase == "UF" then
        "#{ActionController::Base.helpers.number_to_currency(value.to_i, format: "%n %u", unit: "UF", :precision => 0)}"
      elsif params[:currency].upcase == "MXN" then
        "#{ActionController::Base.helpers.number_to_currency(value.to_i, format: "%n %u", unit: "MX", :precision => 0)}"
      elsif params[:currency].upcase == "COP" then
        "#{ActionController::Base.helpers.number_to_currency(value.to_i, format: "%n %u", unit: "COP", :precision => 0)}"
      elsif params[:currency].upcase == "CRC" then
        "#{ActionController::Base.helpers.number_to_currency(value.to_i, format: "%n %u", unit: "CRC", :precision => 0)}"
      else
        "#{ActionController::Base.helpers.number_to_currency(value.to_i, :precision => 0)}"
      end
    end

    vendor = Vendor.where("LOWER (name) = ?", $VENDOR.downcase)
    
    max_value_ext = values.max.round(-5, half: :up) # Redondear el valor máximo al múltiplo de 100.000 más cercano
    max_value_ext += 100000 - (max_value_ext % 100000) # Redondear hacia arriba al múltiplo de 100.000 más cercano

    g.show_vertical_markers = true
    g.marker_color = "#E9EBF1"
    g.marker_shadow_color = "grey"
    g.hide_legend = true
    g.hide_title = true
    g.line_width = 2
    g.dot_radius = 0
    g.marker_x_count = (values.count / 2).to_i
    g.marker_count = 3
    g.colors = vendor.present? ? ["##{rel.vendor.json_vars["table_border"]}"] : ["#AAABFF"]
    g.minimum_value = params[:currency].upcase == 'UF' ? min_value : min_value_delta
    g.maximum_value = params[:currency].upcase == 'UF' ? max_value : max_value_delta
    g.marker_font_size = 12
    g.margins = 0
    g.right_margin = 20
    g.write(chart_file)
  end

  def self.create_pdf rel, params, chart_file, pdf_file

    dollar = DollarPrice.step_business_day
    euro = EuroPrice.step_business_day
    uf = UfPrice.step_business_day
    mxn = MxnPrice.step_business_day
    cop = CopPrice.step_business_day
    crc = CrcPrice.step_business_day

    vendor_vars = get_vendor_vars(rel)
    
    assetvalue = params[:assetvalue]
    balances = JSON.parse SelectedAccountsBalanceJob.perform_now(rel, params[:ids], params[:window]).balances_values

    accounts = Account.find params[:ids]
    accounts_names = accounts.collect(&:name).join(', ')

    investments = rel.relation_accounts.where(id: params[:ids])

    date_from = balances.keys.to_a.last
    date_to = balances.keys.first

    # Get consolidated balance
    selected_accounts_balance = 0
    investments.each do |inv|
      inv.sub_accounts.each do |acc|
        acc.memberships.each do |membership|
          if !membership.amount_updated_balance.nil? then
            selected_accounts_balance = selected_accounts_balance + membership.amount_updated_balance
          end
        end
      end
    end

    # ===========================
    total_consolidated = 0
    investments.each do |inv|
      inv.sub_accounts.each do |acc|
        total_valor_cierre = 0
        acc.memberships.each do |membership|
          if membership.amount_updated_balance.to_i > 0 then
            total_valor_cierre += membership.amount_updated_balance
          end
        end
        if acc.currency.upcase == "CLP" then
          total_valor_cierre = total_valor_cierre / dollar
        end
        if acc.currency.upcase == "EUR" then
          total_valor_cierre = (total_valor_cierre * euro) / dollar
        end
        if acc.currency.upcase == "UF" then
          total_valor_cierre = (total_valor_cierre * uf) / dollar
        end
        if acc.currency.upcase == "MXN" then
          total_valor_cierre = (total_valor_cierre * mxn) / dollar
        end
        if acc.currency.upcase == "COP" then
          total_valor_cierre = (total_valor_cierre * cop) / dollar
        end
        if acc.currency.upcase == "CRC" then
          total_valor_cierre = (total_valor_cierre * crc) / dollar
        end
        total_consolidated += total_valor_cierre
      end
    end
    # ===========================

    if params[:currency].upcase == "CLP" then
      total_consolidated = total_consolidated * dollar
    end

    if params[:currency].upcase == "EUR" then
      total_consolidated = (total_consolidated * dollar) / euro
    end

    if params[:currency].upcase == "UF" then
      total_consolidated = (total_consolidated * dollar) / uf
    end

    if params[:currency].upcase == "MXN" then
      total_consolidated = (total_consolidated * dollar) / mxn
    end

    if params[:currency].upcase == "COP" then
      total_consolidated = (total_consolidated * dollar) / cop
    end

    if params[:currency].upcase == "CRC" then
      total_consolidated = (total_consolidated * dollar) / crc
    end

    info = {
      Title: assetvalue === 'investment' ? 'Reporte de Inversiones' : 
        assetvalue === 'real_estate' ? 'Reporte de Bienes Raíces' : 
        assetvalue === 'pension_fund' ? 'Reporte de Pensiones' : 
        'Otros' , 
      Author: 'Duendes de Valuelist',
      Creator: 'Value List',
      CreationDate: Time.now
    }
    Prawn::Document.generate(pdf_file, { :page_size => 'LETTER', :margin => [40, 35, 40, 35], :info => info }) do

      # Images
      logo = Rails.root.join("app/assets/images/logo-" + $VENDOR.downcase + ".png")
      logo_grey = Rails.root.join("app/assets/images/logo-gris.png")
      chart = chart_file

      # Fonts
      font_families.update("Poppins" => {
        :black => Rails.root.join("app/assets/fonts/Poppins/Poppins-Black.ttf"),
        :bold => Rails.root.join("app/assets/fonts/Poppins/Poppins-Bold.ttf"),
        :italic => Rails.root.join("app/assets/fonts/Poppins/Poppins-Italic.ttf"),
        :light => Rails.root.join("app/assets/fonts/Poppins/Poppins-Light.ttf"),
        :medium => Rails.root.join("app/assets/fonts/Poppins/Poppins-Medium.ttf"),
        :normal => Rails.root.join("app/assets/fonts/Poppins/Poppins-Regular.ttf"),
        :thin => Rails.root.join("app/assets/fonts/Poppins/Poppins-Thin.ttf"),
        :regular => Rails.root.join("app/assets/fonts/Poppins/Poppins-Regular.ttf"),
        :semibold => Rails.root.join("app/assets/fonts/Poppins/Poppins-SemiBold.ttf"),
      })
      font_families.update("Inter" => {
        :black => Rails.root.join("app/assets/fonts/Inter/Inter-Black.ttf"),
        :bold => Rails.root.join("app/assets/fonts/Inter/Inter-Bold.ttf"),
        :italic => Rails.root.join("app/assets/fonts/Inter/Inter-Italic.ttf"),
        :light => Rails.root.join("app/assets/fonts/Inter/Inter-Light.ttf"),
        :medium => Rails.root.join("app/assets/fonts/Inter/Inter-Medium.ttf"),
        :normal => Rails.root.join("app/assets/fonts/Inter/Inter-Regular.ttf"),
        :thin => Rails.root.join("app/assets/fonts/Inter/Inter-Thin.ttf"),
        :regular => Rails.root.join("app/assets/fonts/Inter/Inter-Regular.ttf"),
        :semibold => Rails.root.join("app/assets/fonts/Inter/Inter-SemiBold.ttf"),
      })
      font_families.update("Roboto" => {
        :black => Rails.root.join("app/assets/fonts/Roboto/Roboto-Black.ttf"),
        :bold => Rails.root.join("app/assets/fonts/Roboto/Roboto-Bold.ttf"),
        :italic => Rails.root.join("app/assets/fonts/Roboto/Roboto-Italic.ttf"),
        :light => Rails.root.join("app/assets/fonts/Roboto/Roboto-Light.ttf"),
        :medium => Rails.root.join("app/assets/fonts/Roboto/Roboto-Medium.ttf"),
        :normal => Rails.root.join("app/assets/fonts/Roboto/Roboto-Regular.ttf"),
        :thin => Rails.root.join("app/assets/fonts/Roboto/Roboto-Thin.ttf"),
        :regular => Rails.root.join("app/assets/fonts/Roboto/Roboto-Regular.ttf"),
        :semibold => Rails.root.join("app/assets/fonts/Roboto/Roboto-SemiBold.ttf"),
      })


      # Footer
      repeat(:all) do
        font "Inter"
        fill_color vendor_vars[:bank_footer_text]
        draw_text "Datos exportados desde la plataforma de", :size => 9, :style => :regular, :at => [170, 1]
        image logo_grey, at: [350, 9], width: 52
      end
      define_grid(columns: 3, rows: 20, gutter: 5)
     
      # Logo
      grid(0, 0).bounding_box do
        image logo, height: 30
      end

      # Header
      grid([0, 2], [3, 2]).bounding_box do
        font "Inter", :style => :normal, :size => 9
        fill_color vendor_vars[:document_body_text]
        text "<b>Fechas:</b> " + date_from + " a " + date_to, :inline_format => true
        move_down 1
        text "<b>Moneda:</b> " + params[:currency].upcase, :inline_format => true
        move_down 1
        if params[:currency].upcase == "CLP" then
          text "<b>Valor de referencia Dolar </b>" + ActionController::Base.helpers.number_to_currency(dollar) + " CLP", :inline_format => true
          move_down 1
        elsif params[:currency].upcase == "EUR" then
          text "<b>Valor de referencia Dolar </b>" + ActionController::Base.helpers.number_to_currency(dollar/euro) + " EUR", :inline_format => true
          move_down 1
        elsif params[:currency].upcase == "UF" then
          text "<b>Valor de referencia Dolar </b>" + ActionController::Base.helpers.number_to_currency(dollar/uf) + " UF", :inline_format => true
          move_down 1
        elsif params[:currency].upcase == "MXN" then
          text "<b>Valor de referencia Dolar </b>" + ActionController::Base.helpers.number_to_currency(dollar/mxn) + " MXN", :inline_format => true
          move_down 1
        elsif params[:currency].upcase == "COP" then
          text "<b>Valor de referencia Dolar </b>" + ActionController::Base.helpers.number_to_currency(dollar/cop) + " COP", :inline_format => true
          move_down 1
        elsif params[:currency].upcase == "CRC" then
          text "<b>Valor de referencia Dolar </b>" + ActionController::Base.helpers.number_to_currency(dollar/crc) + " CRC", :inline_format => true
          move_down 1
        else 
          move_down 1
        end
      end

      # Name
      grid([2, 0], [2, 2]).bounding_box do
        font "Poppins"
        fill_color vendor_vars[:document_body_text]
        draw_text rel.first_name + ' ' + rel.last_name, :size => 17, :style => :bold, at: [0, 0]
      end

      # Accounts
      grid([3, 0], [4, 2]).bounding_box do
        font "Inter"
        fill_color vendor_vars[:document_body_text]
        move_down 10
        text "<b>Cuentas:</b>", :style => :normal, :size => 9, :inline_format => true
        move_down 1
        text accounts_names, :style => :normal, :size => 9, :inline_format => true
      end

      # Calculo del espacio para las cuentas 
      account_space_heigth = (accounts_names.length / 240)
      account_space_heigth = account_space_heigth < 0 ? 0 : account_space_heigth

      # Disclaimer
      grid([4 + account_space_heigth, 0], [4 + account_space_heigth, 2]).bounding_box do
        font "Inter"
        fill_color vendor_vars[:document_body_text]
        draw_text "La siguiente información corresponde al consolidado en el rango de tiempo, moneda y cuentas seleccionadas.", :size => 9, :style => :medium, at: [0, 10]
      end

      # SALDO INSOLUTO TOTAL
      grid([5 + account_space_heigth, 0], [5 + account_space_heigth, 2]).bounding_box do
        font "Inter"
        fill_color vendor_vars[:document_body_text]
        draw_text "CAPITAL CONSOLIDADO", :size => 9, :style => :normal, :inline_format => true, at: [0, 20]
        font "Poppins"
        if params[:currency].upcase == "USD" then
          draw_text ActionController::Base.helpers.number_to_currency(total_consolidated, :locale => :en, :precision => 0).to_s, :size => 17, :style => :medium, :inline_format => true, at: [0, 0]
        elsif params[:currency].upcase == "EUR" then
          draw_text ActionController::Base.helpers.number_to_currency(total_consolidated, format: "%n %u", unit: "€", :precision => 0).to_s, :size => 17, :style => :medium, :inline_format => true, at: [0, 0]
        elsif params[:currency].upcase == "UF" then
          draw_text ActionController::Base.helpers.number_to_currency(total_consolidated, format: "%n %u", unit: "UF", :precision => 0).to_s, :size => 17, :style => :medium, :inline_format => true, at: [0, 0]
        elsif params[:currency].upcase == "MXN" then
          draw_text ActionController::Base.helpers.number_to_currency(total_consolidated, format: "%n %u", unit: "MX", :precision => 0).to_s, :size => 17, :style => :medium, :inline_format => true, at: [0, 0]
        elsif params[:currency].upcase == "COP" then
          draw_text ActionController::Base.helpers.number_to_currency(total_consolidated, format: "%n %u", unit: "COP", :precision => 0).to_s, :size => 17, :style => :medium, :inline_format => true, at: [0, 0]
        elsif params[:currency].upcase == "CRC" then
          draw_text ActionController::Base.helpers.number_to_currency(total_consolidated, format: "%n %u", unit: "CRC", :precision => 0).to_s, :size => 17, :style => :medium, :inline_format => true, at: [0, 0]
        else
          draw_text ActionController::Base.helpers.number_to_currency(total_consolidated, :precision => 0).to_s, :size => 17, :style => :medium, :inline_format => true, at: [0, 0]
        end
      end

      # Chart
      grid([6 + account_space_heigth, 0], [20 + account_space_heigth, 2]).bounding_box do
        move_down 10
        image chart_file, width: bounds.width
      end
      
      # grid.show_all # Para mostrar la grilla

       #Tablas PDF para Investments
      start_new_page
      
      font "Poppins"
      fill_color vendor_vars[:titles_text]
      text assetvalue === 'investment' ? 'Inversiones' : 
        assetvalue === 'real_estate' ? 'Bienes Raíces' : 
        assetvalue === 'pension_fund' ? 'Pensiones' : 
        assetvalue === 'liability' ? 'Pasivos' : 
        assetvalue === 'others' ? 'Otros' : 
        'Otros' , 
      :size => 13, :style => :semibold, :inline_format => true
      move_down 10

      if assetvalue === 'real_estate' then
        investments.each do |inv|
          font "Poppins"
          fill_color vendor_vars[:titles_text]
          formatted_text([{ :text => inv.name , :size => 9, :style => :semibold, :color => vendor_vars[:titles_text] }])
  
          total_subaccount_inversion = 0
          total_subaccount_valor_cierre = 0
          total_subaccount_plusvalia = 0
          total_subaccount_rentabilidad = 0
          total_subaccount_pr = 0
  
          # Tablas PDF para Bienes Raíces 
          
          inv.sub_accounts.each do |acc|
            move_down 10
            font "Roboto"
            formatted_text([{ :text => acc.sub_account_id.upcase, :border_width => 1, :border => :top, :size => 9, :style => :medium, :color => vendor_vars[:titles_text] }, 
              { :text => " (" + acc.currency.upcase + ")",
                :size => 9,
                :style => :medium,
                :color => vendor_vars[:table_lastrow_currency_text],
                  }])
            move_down 9
  
            table_content = [["NOMBRE/ROL", "DESTINO DEL ACTIVO", "COMUNA", "CANTIDAD M²", "COSTO M²", "INVERSIÓN TOTAL", "AVALÚO FISCAL", "VALORIZACIÓN Valuelist", "VALORIZACIÓN EXTERNA", "PLUSVALÍA Y RENTABILIDAD", "PESO"]]
            colors = ["FFFFFF"]
  
            total_etf_patrimony = acc.memberships.sum { |membership| membership.accounts.find_by(name: 'amount_updated')&.balance.to_f }
  
            total_external_valorization = 0
            total_plusvalia = 0
            total_rentabilidad = 0
            total_pr = 0
            
            currency_format = acc.currency.upcase == "USD" ? :en : :cl
  
            acc.memberships.each do |membership|
  
              if membership.quotas_balance.to_i >= 0 then
  
                row = []
                colors.push("FFFFFF")
  
                etf_patrimony = membership.accounts.find_by(name: 'amount_updated')&.balance.to_f

                costM2 = membership.real_estates[0].area.to_i == 0 ? 0 : membership.real_estates[0].total_inversion.to_f / membership.real_estates[0].area.to_f
                rentabilidad = costM2 === 0 ? 0 : !membership.real_estates[0].external_valorization.nil? ? (membership.real_estates[0].external_valorization / membership.real_estates[0].total_inversion - 1) * 100 : !membership.real_estates[0].vl_valorization.nil? ? (membership.real_estates[0].vl_valorization / membership.real_estates[0].total_inversion - 1) * 100: 0
                plusvaliaRealEstates = !membership.real_estates[0].external_valorization.nil? ? (membership.real_estates[0].external_valorization - membership.real_estates[0].total_inversion) : !membership.real_estates[0].vl_valorization.nil? ? (membership.real_estates[0].vl_valorization - membership.real_estates[0].total_inversion) : 0
                pr = (etf_patrimony * 100) / total_etf_patrimony
                
                total_external_valorization += membership.real_estates[0].external_valorization if !membership.real_estates[0].external_valorization.nil?
                total_external_valorization += membership.real_estates[0].vl_valorization if !membership.real_estates[0].vl_valorization.nil?
                total_plusvalia += plusvaliaRealEstates
                total_rentabilidad += rentabilidad
                total_pr += pr
  
                row.push membership.investment_asset.name + "\n" + membership.real_estates[0].role # Nombre & Rol
                row.push membership.real_estates[0].asset_destination # Destino de Activo
                row.push membership.real_estates[0].commune # Comuna
                row.push membership.real_estates[0].area.to_i # Cantidad M²
                row.push costM2.round(2) # Costo por M2 falta
                row.push ActionController::Base.helpers.number_to_currency(membership.real_estates[0].total_inversion, :locale => currency_format, :precision => 0) # Inversion total
                row.push ActionController::Base.helpers.number_to_currency(membership.real_estates[0].fiscal_appraisal, :locale => currency_format, :precision => 0) # Avaluo Fiscal

                if !membership.real_estates[0].vl_valorization.nil?
                  row.push ActionController::Base.helpers.number_to_currency(membership.real_estates[0].vl_valorization, :locale => currency_format) + "\n" + DateTime.parse(membership.real_estates[0].vl_valorization_date).strftime("%m-%d-%Y") # Valorización Valuelist y Fecha
                else
                  row.push "-\n-" # Valorización Valuelist y Fecha
                end
                
                if !membership.real_estates[0].external_valorization.nil?
                  row.push ActionController::Base.helpers.number_to_currency(membership.real_estates[0].external_valorization, :locale => currency_format, :precision => 0) + "\n" + membership.real_estates[0].external_valorization_date + "\n" + membership.real_estates[0].external_valorization_name  # Valorización Externa, Fecha e Institución
                else
                  row.push "-\n-\n-" # Valorización Externa, Fecha e Institución
                end

                row.push ActionController::Base.helpers.number_to_currency(plusvaliaRealEstates ? plusvaliaRealEstates : '0', :locale => currency_format, :precision => 0).to_s 
                  + "\n" + 
                  ActionController::Base.helpers.number_to_percentage(rentabilidad).to_s # Plusvalia y rentabilidad
                row.push ActionController::Base.helpers.number_to_percentage(pr) # Peso
                
                font "Roboto", :size => 7, :style => :regular
                fill_color vendor_vars[:table_text]
                table_content.push row
              end
            end
  
            total_subaccount_inversion += total_external_valorization
            total_subaccount_plusvalia += total_plusvalia
            total_subaccount_rentabilidad += total_rentabilidad
            total_subaccount_pr = total_pr
  
            table_content.push [ 
              "TOTAL", 
              "", 
              "", 
              "",
              "",
              "", 
              "",
              "",
              ActionController::Base.helpers.number_to_currency(total_external_valorization, :locale => currency_format, :precision => 0), 
              ActionController::Base.helpers.number_to_currency(total_plusvalia, :locale => currency_format, :precision => 0).to_s + "\n" + ActionController::Base.helpers.number_to_percentage(total_rentabilidad).to_s, 
              ActionController::Base.helpers.number_to_percentage(total_pr, :precision => 0)
            ]
            table_content.push [ "", "", "", "", "", "", "", "", ""]
  
            table(table_content, width: bounds.width, :header => false, :position => :left, :row_colors => colors, :column_widths => [40, 52, 40, 50, 45, 53, 45, 63, 62, 60, 32 ]) do
              cells.borders = []
              cells.padding = [5, 3, 5, 3]
              cells.style do |c|
                c.padding = [8, 3, 3, 3]
                c.font_style = :regular
              end
              
              row(0).size = 7
              row(0).valign = :center
              row(0).padding = [6, 3, 8, 3]
              row(0).font_style = :bold
              row(0).borders = [:top, :bottom]
              row(0).border_color = vendor_vars[:table_border]
              row(0).text_color = vendor_vars[:table_text]
              row(0).background_color = "FFFFFF"
  
              row(table_content.count - 2).font_style = :bold
              row(table_content.count - 2).size = 7
              row(table_content.count - 2).background_color = vendor_vars[:background_lastrow]
              row(table_content.count - 2).borders = [:bottom]
              row(table_content.count - 2).border_color = vendor_vars[:table_border]
              row(table_content.count - 2).padding = [8, 3, 10, 3]
              row(table_content.count - 2).valign = :center
            end
          end
  
          table_total_subaccount = [[
            "TOTAL CUENTA", 
            "", 
            "", 
            "", 
            "",
            "",
            "",
            "",
            ActionController::Base.helpers.number_to_currency(total_subaccount_inversion, :precision => 0),
            ActionController::Base.helpers.number_to_currency(total_subaccount_plusvalia, :precision => 0).to_s + "\n" + ActionController::Base.helpers.number_to_percentage(total_subaccount_rentabilidad).to_s,
            ActionController::Base.helpers.number_to_percentage(total_subaccount_pr, :precision => 0),
          ]]
  
          colors = ["FFFFFF"]
          
          table(table_total_subaccount, width: bounds.width, :header => true, :position => :left, :row_colors => colors, :column_widths => [92, 50, 40, 30, 25, 43, 45, 63, 62, 60, 32]) do
    
            row(0).font_style = :bold
            row(0).size = 7
            row(0).background_color = vendor_vars[:background_main_lastrow]
            row(0).text_color = vendor_vars[:table_lastrow_currency_text]
            row(0).borders = [:top, :bottom]
            row(0).border_color = vendor_vars[:table_border]
            row(0).padding = [8, 3, 10, 3]
            row(0).valign = :center
          end

          #Fin Tablas PDF para Bienes Raíces

          text "La información consolidada en este documento es únicamente de carácter informativo y referencial compuesta por varias fuentes de información con la finalidad de otorgar un complemento estimado y aproximado al asesor o usuario que emplee Valuelist. Valuelist no se hace responsable por la exactitud, confiabilidad, soporte, software, textos, gráficos que podrían haber sido obtenidos de terceros que están sujetos a cambios sin previo aviso. Valuelist no emite ninguna declaración expresa respecto a la información descargada. Cualquier error o discrepancia deberá ser comunicado a la brevedad a los contactos de soporte de Valuelist. Para mayor información, leer Términos y condiciones en https://www.Valuelist.cl/terminos-y-condiciones.", 
          :size => 8, 
          :color => vendor_vars[:bank_footer_text],
          :valign => :center,
          :leading => 1,
          :justify => true
          
          font "Inter", :size => 9, :style => :regular
          fill_color vendor_vars[:bank_footer_text]
          move_down 35
        end
      elsif assetvalue === 'liability' then
        investments.each do |inv|
          font "Poppins"
          fill_color vendor_vars[:titles_text]
          formatted_text([{ :text => inv.name , :size => 9, :style => :semibold, :color => vendor_vars[:titles_text] }, 
            { :text => " / " + inv.bank.name,
              :size => 9,
              :style => :medium,
              :color => vendor_vars[:table_text]
  
                }])
  
          total_subaccount_inversion = 0
          total_subaccount_outstanding_balance = 0
          total_subaccount_pr = 0
          
          #Tablas PDF para liabilities
        
          inv.sub_accounts.each do |acc|
            move_down 10
            font "Roboto"
            formatted_text([{ :text => acc.sub_account_id.upcase, :border_width => 1, :border => :top, :size => 9, :style => :medium, :color => vendor_vars[:titles_text] }, 
              { :text => " (" + acc.currency.upcase + ")",
                :size => 9,
                :style => :medium,
                :color => vendor_vars[:table_lastrow_currency_text],
                  }])
            move_down 9
  
            table_content = [["NOMBRE", "ACTIVO ASOCIADO", "DEUDA INICIAL", "FECHA INICIO/FECHA VENC.", "TASA", "CUOTAS PAGADAS", "PERIODICIDAD PAGO", "PRÓX. PAGO", "SALDO INSOLUTO", "PESO"]]
            colors = ["FFFFFF"]
  
            total_etf_patrimony = acc.memberships.sum { |membership| membership.accounts.find_by(name: 'amount_updated')&.balance.to_f }
  
            total_inversion = 0
            total_outstanding_balance = 0
            total_pr = 0
            
            currency_format = acc.currency.upcase == "USD" ? :en : :cl
  
            acc.memberships.each do |membership|
  
              if membership.amount_updated_balance.to_i > 0 then
  
                row = []
                colors.push("FFFFFF")
  
                etf_patrimony = membership.accounts.find_by(name: 'amount_updated')&.balance.to_f
  
                rentabilidad = (membership.incomes_balance.to_f / membership.amount_invested_balance.to_f) * 100
                pr = (etf_patrimony * 100) / total_etf_patrimony
                total_inversion += membership.liabilities[0].initial_debt
                total_outstanding_balance += membership.liabilities[0].outstanding_balance
                total_pr += pr

                row.push membership.liabilities[0].description + "\n" + membership.liabilities[0].name
                row.push membership.liabilities[0].investment_asset_id.nil? ? '' :  membership.liabilities[0].investment_asset.name.to_s # Activo asociado
                row.push "$" + ActionController::Base.helpers.number_to_human(membership.liabilities[0].initial_debt, significant: false) + " (#{ActionController::Base.helpers.number_to_percentage(membership.liabilities[0].debt_participation, :precision => 0)})" # Deuda inicial
                row.push membership.liabilities[0].start_date.to_date.strftime('%d-%m-%y') + "\n" + membership.liabilities[0].end_date.to_date.strftime('%d-%m-%Y') # Fecha inicio/Fecha venc.
                row.push ActionController::Base.helpers.number_to_percentage(membership.liabilities[0].rate, :precision => 1)  + "\n" + membership.liabilities[0].rate_description # tasa
                row.push membership.liabilities[0].fees_paid.to_s + "/" + membership.liabilities[0].total_fees.to_s # Cuotas pagadas
                row.push I18n.t("activerecord.attributes.liability.payment_cycle.#{membership.liabilities[0].payment_cycle}") # Periodicidad pago
                row.push membership.liabilities[0].next_payment_date.to_date.strftime('%d-%m-%y')  + "\n Quedan " + membership.liabilities[0].days_to_next_payment_date.to_s + " días" # Proximo pago
                row.push "$" + ActionController::Base.helpers.number_to_human(membership.liabilities[0].outstanding_balance, significant: false) + " (#{ActionController::Base.helpers.number_to_percentage(membership.liabilities[0].debt_participation, :precision => 0)})" # Deuda inicial
                row.push ActionController::Base.helpers.number_to_percentage(pr, :precision => 0) # Peso
                
                font "Roboto", :size => 7, :style => :regular
                fill_color vendor_vars[:table_text]
                table_content.push row
              end
            end
  
            total_subaccount_inversion = total_subaccount_inversion + total_inversion
            total_subaccount_outstanding_balance = total_subaccount_outstanding_balance + total_outstanding_balance
            total_subaccount_pr = total_pr
  
            table_content.push [ 
              "TOTAL", 
              "", 
              "$" + ActionController::Base.helpers.number_to_human(total_inversion, significant: false), # Total deuda inicial
              "", 
              "", 
              "",
              "",
              "",
              "$" + ActionController::Base.helpers.number_to_human(total_outstanding_balance, significant: false), # Total saldo insoluto
              ActionController::Base.helpers.number_to_percentage(total_pr, :precision => 0)
            ]
            table_content.push [ "", "", "", "", "", "", "", "", "", ""]
  
            table(
              table_content, 
              width: 542, 
              :header => false, 
              :position => :left, 
              :row_colors => colors, 
              :column_widths => [92, 50, 50, 50, 50, 50, 50, 50, 50, 50]
            ) do
              cells.borders = []
              cells.padding = [5, 3, 5, 3]
              cells.style do |c|
                c.padding = [8, 3, 3, 3]
                c.font_style = :regular
              end
              
              row(0).size = 7
              row(0).valign = :center
              row(0).padding = [6, 3, 8, 3]
              row(0).font_style = :bold
              row(0).borders = [:top, :bottom]
              row(0).border_color = vendor_vars[:table_border]
              row(0).text_color = vendor_vars[:table_text]
              row(0).background_color = "FFFFFF"
  
              row(table_content.count - 2).font_style = :bold
              row(table_content.count - 2).size = 7
              row(table_content.count - 2).background_color = vendor_vars[:background_lastrow]
              row(table_content.count - 2).borders = [:bottom]
              row(table_content.count - 2).border_color = vendor_vars[:table_border]
              row(table_content.count - 2).padding = [8, 3, 10, 3]
              row(table_content.count - 2).valign = :center
            end
          end

          table_total_subaccount = [[
            "TOTAL CUENTA", 
            "", 
            "$" + ActionController::Base.helpers.number_to_human(total_subaccount_inversion, significant: false),
            "", 
            "",
            "",
            "",
            "$" + ActionController::Base.helpers.number_to_human(total_subaccount_outstanding_balance, significant: false),
            ActionController::Base.helpers.number_to_percentage(total_subaccount_pr, :precision => 0),
          ]]
  
          colors = ["FFFFFF"]
          
          table(
            table_total_subaccount, 
            width: 542, 
            :header => true, 
            :position => :left, 
            :row_colors => colors, 
            :column_widths => [95, 55, 92, 50, 50, 50, 50, 50, 50, 50]
            ) do
    
            row(0).font_style = :bold
            row(0).size = 7
            row(0).background_color = vendor_vars[:background_main_lastrow]
            row(0).text_color = vendor_vars[:table_lastrow_currency_text]
            row(0).borders = [:top, :bottom]
            row(0).border_color = vendor_vars[:table_border]
            row(0).padding = [8, 3, 10, 3]
            row(0).valign = :center
          end
          #Fin Tablas PDF para liabilities

          text "La información consolidada en este documento es únicamente de carácter informativo y referencial compuesta por varias fuentes de información con la finalidad de otorgar un complemento estimado y aproximado al asesor o usuario que emplee Valuelist. Valuelist no se hace responsable por la exactitud, confiabilidad, soporte, software, textos, gráficos que podrían haber sido obtenidos de terceros que están sujetos a cambios sin previo aviso. Valuelist no emite ninguna declaración expresa respecto a la información descargada. Cualquier error o discrepancia deberá ser comunicado a la brevedad a los contactos de soporte de Valuelist. Para mayor información, leer Términos y condiciones en https://www.valuelist.cl/terminos-y-condiciones.", 
          :size => 8, 
          :color => vendor_vars[:bank_footer_text],
          :valign => :center,
          :leading => 1,
          :justify => true

          font "Inter", :size => 9, :style => :regular
          fill_color vendor_vars[:bank_footer_text]
          move_down 35
        end
      elsif assetvalue == 'others'
        investments.each do |inv|
          font "Poppins"
          fill_color vendor_vars[:titles_text]
          formatted_text([{ :text => inv.name , :size => 9, :style => :semibold, :color => vendor_vars[:titles_text] }, 
            { :text => " / " + inv.bank.name,
              :size => 9,
              :style => :medium,
              :color => vendor_vars[:table_text]
  
                }])
  
          total_subaccount_inversion = 0
          total_subaccount_valor_cierre = 0
          total_subaccount_plusvalia = 0
          total_subaccount_rentabilidad = 0
          total_subaccount_pr = 0
                  
          inv.sub_accounts.each do |acc|
            move_down 10
            font "Roboto"
            formatted_text([{ :text => acc.sub_account_id.upcase, :border_width => 1, :border => :top, :size => 9, :style => :medium, :color => vendor_vars[:titles_text] }, 
              { :text => " (" + acc.currency.upcase + ")",
                :size => 9,
                :style => :medium,
                :color => vendor_vars[:table_lastrow_currency_text],
                  }])
            move_down 9
  
            table_content = [["NOMBRE", "", "CANTIDAD", "", "INVERSIÓN TOTAL", "", "VALORIZACIÓN EXTERNA", "PLUSVALÍA Y RENTABILIDAD", "PESO"]]
            colors = ["FFFFFF"]
  
            total_etf_patrimony = acc.memberships.sum { |membership| membership.accounts.find_by(name: 'amount_updated')&.balance.to_f }
  
            total_inversion = 0
            total_valor_cierre = 0
            total_plusvalia = 0
            total_rentabilidad = 0
            total_pr = 0
            
            currency_format = acc.currency.upcase == "USD" ? :en : :cl
  
            acc.memberships.each do |membership|
  
              if membership.quotas_balance.to_i > 0 then
  
                row = []
                colors.push("FFFFFF")
  
                etf_patrimony = membership.accounts.find_by(name: 'amount_updated')&.balance.to_f
  
                rentabilidad = (membership.incomes_balance.to_f / membership.amount_invested_balance.to_f) * 100
                pr = (etf_patrimony * 100) / total_etf_patrimony
                total_inversion += membership.amount_invested_balance
                total_valor_cierre += membership.others_memberships&.last&.external_valorization
                total_plusvalia += membership.incomes_balance.to_i
                total_rentabilidad += rentabilidad
                total_pr += pr
  
                row.push membership.investment_asset.name # Nombre & Instrumento
                row.push ''
                row.push membership.quotas_balance.to_i # Cantidad
                row.push '' # Costo
                row.push ActionController::Base.helpers.number_to_currency(membership.amount_invested_balance, :locale => currency_format, :precision => 0) # Inversion total
                row.push ''
                row.push ActionController::Base.helpers.number_to_currency(membership.others_memberships&.last&.external_valorization, :locale => currency_format, :precision=> 0).to_s + "\n" + membership.others_memberships&.last&.created_at.strftime("%m-%d-%Y")# Valorización Externa
                row.push ActionController::Base.helpers.number_to_currency(membership.incomes_balance ? membership.incomes_balance : '0', :locale => currency_format, :precision => 0).to_s + "\n" + ActionController::Base.helpers.number_to_percentage(rentabilidad).to_s # Plusvalia y rentabilidad
                row.push ActionController::Base.helpers.number_to_percentage(pr, :precision => 0) # Peso
                
                font "Roboto", :size => 7, :style => :regular
                fill_color vendor_vars[:table_text]
                table_content.push row
              end
            end
  
            total_subaccount_inversion += total_inversion
            total_subaccount_valor_cierre += total_valor_cierre
            total_subaccount_plusvalia += total_plusvalia
            total_subaccount_rentabilidad += total_rentabilidad
            total_subaccount_pr = total_pr
  
            table_content.push [ 
              "TOTAL", 
              "", 
              "", 
              "", 
              ActionController::Base.helpers.number_to_currency(total_inversion, :locale => currency_format, :precision => 0), 
              "",
              ActionController::Base.helpers.number_to_currency(total_valor_cierre, :locale => currency_format, :precision => 0), 
              ActionController::Base.helpers.number_to_currency(total_plusvalia, :locale => currency_format, :precision => 0).to_s + "\n" + ActionController::Base.helpers.number_to_percentage(total_rentabilidad).to_s, 
              ActionController::Base.helpers.number_to_percentage(total_pr, :precision => 0)
            ]
            table_content.push [ "", "", "", "", "", "", "", "", ""]
  
            table(table_content, width: bounds.width, :header => false, :position => :left, :row_colors => colors, :column_widths => [92, 65, 45, 40, 72, 60, 65, 70, 33]) do
              cells.borders = []
              cells.padding = [5, 3, 5, 3]
              cells.style do |c|
                c.padding = [8, 3, 3, 3]
                c.font_style = :regular
              end
              
              row(0).size = 7
              row(0).valign = :center
              row(0).padding = [6, 3, 8, 3]
              row(0).font_style = :bold
              row(0).borders = [:top, :bottom]
              row(0).border_color = vendor_vars[:table_border]
              row(0).text_color = vendor_vars[:table_text]
              row(0).background_color = "FFFFFF"
  
              row(table_content.count - 2).font_style = :bold
              row(table_content.count - 2).size = 7
              row(table_content.count - 2).background_color = vendor_vars[:background_lastrow]
              row(table_content.count - 2).borders = [:bottom]
              row(table_content.count - 2).border_color = vendor_vars[:table_border]
              row(table_content.count - 2).padding = [8, 3, 10, 3]
              row(table_content.count - 2).valign = :center
            end
          end

          table_total_subaccount = [[
            "TOTAL CUENTA", 
            "", 
            "", 
            "", 
            ActionController::Base.helpers.number_to_currency(total_subaccount_inversion, :precision => 0), 
            "",
            ActionController::Base.helpers.number_to_currency(total_subaccount_valor_cierre, :precision => 0),
            ActionController::Base.helpers.number_to_currency(total_subaccount_plusvalia, :precision => 0).to_s + "\n" + ActionController::Base.helpers.number_to_percentage(total_subaccount_rentabilidad).to_s,
            ActionController::Base.helpers.number_to_percentage(total_subaccount_pr, :precision => 0),
          ]]
  
          colors = ["FFFFFF"]
          
          table(table_total_subaccount, width: bounds.width, :header => true, :position => :left, :row_colors => colors, :column_widths => [92, 65, 45, 40, 72, 60, 65, 70, 33]) do
    
            row(0).font_style = :bold
            row(0).size = 7
            row(0).background_color = vendor_vars[:background_main_lastrow]
            row(0).text_color = vendor_vars[:table_lastrow_currency_text]
            row(0).borders = [:top, :bottom]
            row(0).border_color = vendor_vars[:table_border]
            row(0).padding = [8, 3, 10, 3]
            row(0).valign = :center
          end
          #Fin Tablas PDF para others

          text "La información consolidada en este documento es únicamente de carácter informativo y referencial compuesta por varias fuentes de información con la finalidad de otorgar un complemento estimado y aproximado al asesor o usuario que emplee Valuelist. Valuelist no se hace responsable por la exactitud, confiabilidad, soporte, software, textos, gráficos que podrían haber sido obtenidos de terceros que están sujetos a cambios sin previo aviso. Valuelist no emite ninguna declaración expresa respecto a la información descargada. Cualquier error o discrepancia deberá ser comunicado a la brevedad a los contactos de soporte de Valuelist. Para mayor información, leer Términos y condiciones en https://www.valuelist.cl/terminos-y-condiciones.", 
          :size => 8, 
          :color => vendor_vars[:bank_footer_text],
          :valign => :center,
          :leading => 1,
          :justify => true
          
          font "Inter", :size => 9, :style => :regular
          fill_color vendor_vars[:bank_footer_text]
          move_down 35
        end
      else
        investments.each do |inv|
          font "Poppins"
          fill_color vendor_vars[:titles_text]
          formatted_text([{ :text => inv.name , :size => 9, :style => :semibold, :color => vendor_vars[:titles_text] }, 
            { :text => " / " + inv.bank.name,
              :size => 9,
              :style => :medium,
              :color => vendor_vars[:table_text]
  
                }])
  
          total_subaccount_inversion = 0
          total_subaccount_valor_cierre = 0
          total_subaccount_plusvalia = 0
          total_subaccount_rentabilidad = 0
          total_subaccount_pr = 0
          
          #Tablas PDF para Investments
        
          inv.sub_accounts.each do |acc|
            move_down 10
            font "Roboto"
            formatted_text([{ :text => acc.sub_account_id.upcase, :border_width => 1, :border => :top, :size => 9, :style => :medium, :color => vendor_vars[:titles_text] }, 
              { :text => " (" + acc.currency.upcase + ")",
                :size => 9,
                :style => :medium,
                :color => vendor_vars[:table_lastrow_currency_text],
                  }])
            move_down 9
  
            table_content = [["NOMBRE", "TIPO DE ACTIVO", "CANTIDAD", "COSTO", "INVERSIÓN TOTAL", "PRECIO CIERRE", "MONTO ACTUAL", "PLUSVALÍA Y RENTABILIDAD", "PESO"]]
            colors = ["FFFFFF"]
  
            total_etf_patrimony = acc.memberships.sum { |membership| membership.accounts.find_by(name: 'amount_updated')&.balance.to_f }
  
            total_inversion = 0
            total_valor_cierre = 0
            total_plusvalia = 0
            total_rentabilidad = 0
            total_pr = 0
            
            currency_format = acc.currency.upcase == "USD" ? :en : :cl
  
            acc.memberships.each do |membership|
  
              if membership.quotas_balance.to_i > 0 then
  
                row = []
                colors.push("FFFFFF")
  
                etf_patrimony = membership.accounts.find_by(name: 'amount_updated')&.balance.to_f
  
                rentabilidad = (membership.incomes_balance.to_f / membership.amount_invested_balance.to_f) * 100
                pr = (etf_patrimony * 100) / total_etf_patrimony
                total_inversion += membership.amount_invested_balance
                total_valor_cierre += membership.amount_updated_balance
                total_plusvalia += membership.incomes_balance.to_i
                total_rentabilidad += rentabilidad
                total_pr += pr
  
                row.push membership.investment_asset.name + "\n" + membership.investment_asset.asset_id # Nombre & Instrumento
                row.push I18n.t('activerecord.attributes.investment_assets.asset_type.' + membership.investment_asset.asset_type) # Tipo de Activo
                row.push membership.quotas_balance.to_i # Cantidad
                row.push ActionController::Base.helpers.number_to_currency(membership.quota_average_price, :locale => currency_format) # Costo
                row.push ActionController::Base.helpers.number_to_currency(membership.amount_invested_balance, :locale => currency_format, :precision => 0) # Inversion total
                row.push ActionController::Base.helpers.number_to_currency(membership.updated_quota_average_price, :locale => currency_format) # Precio cierre
                row.push ActionController::Base.helpers.number_to_currency(membership.amount_updated_balance, :locale => currency_format, :precision => 0) # Monto Actual
                row.push ActionController::Base.helpers.number_to_currency(membership.incomes_balance ? membership.incomes_balance : '0', :locale => currency_format, :precision => 0).to_s + "\n" + ActionController::Base.helpers.number_to_percentage(rentabilidad).to_s # Plusvalia y rentabilidad
                row.push ActionController::Base.helpers.number_to_percentage(pr) # Peso
                
                font "Roboto", :size => 7, :style => :regular
                fill_color vendor_vars[:table_text]
                table_content.push row
              end
            end
  
            total_subaccount_inversion += total_inversion
            total_subaccount_valor_cierre += total_valor_cierre
            total_subaccount_plusvalia += total_plusvalia
            total_subaccount_rentabilidad += total_rentabilidad
            total_subaccount_pr = total_pr
  
            table_content.push [ 
              "TOTAL", 
              "", 
              "", 
              "", 
              ActionController::Base.helpers.number_to_currency(total_inversion, :locale => currency_format, :precision => 0), 
              "",
              ActionController::Base.helpers.number_to_currency(total_valor_cierre, :locale => currency_format, :precision => 0), 
              ActionController::Base.helpers.number_to_currency(total_plusvalia, :locale => currency_format, :precision => 0).to_s + "\n" + ActionController::Base.helpers.number_to_percentage(total_rentabilidad).to_s, 
              ActionController::Base.helpers.number_to_percentage(total_pr, :precision => 0)
            ]
            table_content.push [ "", "", "", "", "", "", "", "", ""]
  
            table(table_content, width: bounds.width, :header => false, :position => :left, :row_colors => colors, :column_widths => [92, 65, 45, 40, 72, 60, 65, 70, 33]) do
              cells.borders = []
              cells.padding = [5, 3, 5, 3]
              cells.style do |c|
                c.padding = [8, 3, 3, 3]
                c.font_style = :regular
              end
              
              row(0).size = 7
              row(0).valign = :center
              row(0).padding = [6, 3, 8, 3]
              row(0).font_style = :bold
              row(0).borders = [:top, :bottom]
              row(0).border_color = vendor_vars[:table_border]
              row(0).text_color = vendor_vars[:table_text]
              row(0).background_color = "FFFFFF"
  
              row(table_content.count - 2).font_style = :bold
              row(table_content.count - 2).size = 7
              row(table_content.count - 2).background_color = vendor_vars[:background_lastrow]
              row(table_content.count - 2).borders = [:bottom]
              row(table_content.count - 2).border_color = vendor_vars[:table_border]
              row(table_content.count - 2).padding = [8, 3, 10, 3]
              row(table_content.count - 2).valign = :center
            end
          end

          table_total_subaccount = [[
            "TOTAL CUENTA", 
            "", 
            "", 
            "", 
            ActionController::Base.helpers.number_to_currency(total_subaccount_inversion), 
            "",
            ActionController::Base.helpers.number_to_currency(total_subaccount_valor_cierre),
            ActionController::Base.helpers.number_to_currency(total_subaccount_plusvalia, :precision => 0).to_s + "\n" + ActionController::Base.helpers.number_to_percentage(total_subaccount_rentabilidad).to_s,
            ActionController::Base.helpers.number_to_percentage(total_subaccount_pr, :precision => 0),
          ]]
  
          colors = ["FFFFFF"]
          
          table(table_total_subaccount, width: bounds.width, :header => true, :position => :left, :row_colors => colors, :column_widths => [92, 65, 45, 40, 72, 60, 65, 70, 33]) do
    
            row(0).font_style = :bold
            row(0).size = 7
            row(0).background_color = vendor_vars[:background_main_lastrow]
            row(0).text_color = vendor_vars[:table_lastrow_currency_text]
            row(0).borders = [:top, :bottom]
            row(0).border_color = vendor_vars[:table_border]
            row(0).padding = [8, 3, 10, 3]
            row(0).valign = :center
          end
          #Fin Tablas PDF para investment / pension_funds

          
          text "La información consolidada en este documento es únicamente de carácter informativo y referencial compuesta por varias fuentes de información con la finalidad de otorgar un complemento estimado y aproximado al asesor o usuario que emplee Valuelist. Valuelist no se hace responsable por la exactitud, confiabilidad, soporte, software, textos, gráficos que podrían haber sido obtenidos de terceros que están sujetos a cambios sin previo aviso. Valuelist no emite ninguna declaración expresa respecto a la información descargada. Cualquier error o discrepancia deberá ser comunicado a la brevedad a los contactos de soporte de Valuelist. Para mayor información, leer Términos y condiciones en https://www.Valuelist.cl/terminos-y-condiciones.", 
          :size => 8, 
          :color => vendor_vars[:bank_footer_text],
          :valign => :center,
          :leading => 1,
          :justify => true

          font "Inter", :size => 9, :style => :regular
          fill_color vendor_vars[:bank_footer_text]
          move_down 35
        end
      end
    end
  end

  def balance_by_asset_type
    accounts = relation_accounts
    balance = {}
    balance[:total] = {}
    balance[:total][:CLP] = self.updated_balance.to_f
    balance[:total][:USD] = self.updated_balance.to_f / dollar
    balance[:total][:EUR] = self.updated_balance.to_f / euro
    balance[:total][:UF] = self.updated_balance.to_f / uf
    balance[:total][:MXN] = self.updated_balance.to_f / mxn
    balance[:total][:COP] = self.updated_balance.to_f / cop
    balance[:total][:CRC] = self.updated_balance.to_f / crc
    balance[:investment] = {CLP: 0, USD: 0, EUR: 0, UF: 0, MXN: 0, COP: 0, CRC: 0}
    balance[:real_estate] = {CLP: 0, USD: 0, EUR: 0, UF: 0, MXN: 0, COP: 0, CRC: 0}
    balance[:pension_fund] = {CLP: 0, USD: 0, EUR: 0, UF: 0, MXN: 0, COP: 0, CRC: 0}
    balance[:liability] = {CLP: 0, USD: 0, EUR: 0, UF: 0, MXN: 0, COP: 0, CRC: 0}
    balance[:other] = {CLP: 0, USD: 0, EUR: 0, UF: 0, MXN: 0, COP: 0, CRC: 0}
    balance[:insurance] = {CLP: 0, USD: 0, EUR: 0, UF: 0, MXN: 0, COP: 0, CRC: 0}
    balance[:investment_insurance] = {CLP: 0, USD: 0, EUR: 0, UF: 0, MXN: 0, COP: 0, CRC: 0}
    puts accounts.inspect
    accounts.all.each do |account|
      balance[account.account_type.to_sym][:CLP] += account.updated_balance.to_f
      balance[account.account_type.to_sym][:USD] += account.updated_balance.to_f / dollar
      balance[account.account_type.to_sym][:EUR] += account.updated_balance.to_f / euro
      balance[account.account_type.to_sym][:UF] += account.updated_balance.to_f / uf
      balance[account.account_type.to_sym][:MXN] += account.updated_balance.to_f / mxn
      balance[account.account_type.to_sym][:COP] += account.updated_balance.to_f / cop
      balance[account.account_type.to_sym][:CRC] += account.updated_balance.to_f / crc
    end
    balance
  end

  def balance_by_currency  
    accounts = relation_accounts
    balance = {}
    balance[:CLP] = {CLP: 0, USD: 0, EUR: 0, UF: 0, MXN: 0, COP: 0, CRC: 0}
    balance[:USD] = {CLP: 0, USD: 0, EUR: 0, UF: 0, MXN: 0, COP: 0, CRC: 0}
    balance[:EUR] = {CLP: 0, USD: 0, EUR: 0, UF: 0, MXN: 0, COP: 0, CRC: 0}
    balance[:UF] = {CLP: 0, USD: 0, EUR: 0, UF: 0, MXN: 0, COP: 0, CRC: 0}
    balance[:MXN] = {CLP: 0, USD: 0, EUR: 0, UF: 0, MXN: 0, COP: 0, CRC: 0}
    balance[:COP] = {CLP: 0, USD: 0, EUR: 0, UF: 0, MXN: 0, COP: 0, CRC: 0}
    balance[:CRC] = {CLP: 0, USD: 0, EUR: 0, UF: 0, MXN: 0, COP: 0, CRC: 0}
    accounts.all.each do |account|
      account.balance_by_currency.each do |key, value|
        balance[key][:CLP] += value
        balance[key][:USD] += value / dollar
        balance[key][:EUR] += value / euro
        balance[key][:UF] += value / uf
        balance[key][:MXN] += value / mxn
        balance[key][:COP] += value / cop
        balance[key][:CRC] += value / crc
      end
    end
    balance
  end

  # Based on country assign to account
  def balance_by_country
    accounts = relation_accounts
    countries = Country.where(id: accounts.pluck(:country_id))
    balance = {}
    countries.each do |country|
      balance[country.continent] ||= {}
      balance[country.continent][country.name] = {}
      assets_balance = 0
      accounts.where(country_id: country.id).map{|account| assets_balance += account.balance_distribution('assets')}
      balance[country.continent][country.name][:code] = country.iso
      balance[country.continent][country.name][:code] ||= "default"
      balance[country.continent][country.name][:total] = assets_balance
      balance[country.continent][country.name][:assets] = assets_balance
      liabilities_balance = 0
      accounts.where(country_id: country.id).map{|account| liabilities_balance += account.balance_distribution('liabilities')}
      balance[country.continent][country.name][:liabilities] = liabilities_balance
    end
    balance
  end

  # Based on investment_assets countries distribution
  def balance_by_country_2
    balance = {}
    memberships.each do |membership|
      investment_asset = membership.investment_asset
      if investment_asset.countries_percentage.blank?
        country = Country.find_by(name_eng: 'No country')
        balance[country.continent] ||= {}
        balance[country.continent][country.name] ||= {}
        balance[country.continent][country.name][:code] = "default"
        balance[country.continent][country.name][:assets] ||= 0
        balance[country.continent][country.name][:liabilities] ||= 0
        balance[country.continent][country.name][:assets] += membership.updated_balance.to_f unless investment_asset.asset_type == 'liability'
        balance[country.continent][country.name][:liabilities] += membership.updated_balance.to_f if investment_asset.asset_type == 'liability'
        total = investment_asset.asset_type == 'liability' ? (-1 * membership.updated_balance).to_f : (membership.updated_balance).to_f
        balance[country.continent][country.name][:total] ||= 0
        balance[country.continent][country.name][:total] += total
      else
        investment_asset.countries_percentage.each do |country_percentage|
          country = Country.find_by(name_eng: country_percentage.first)
          percentage = country_percentage.second
          next unless percentage > 0 && membership.updated_balance > 0
  
          balance[country.continent] ||= {}
          balance[country.continent][country.name] ||= {}
          balance[country.continent][country.name][:code] ||= country.iso
          balance[country.continent][country.name][:code] ||= "default"
          balance[country.continent][country.name][:assets] ||= 0
          balance[country.continent][country.name][:liabilities] ||= 0
          balance[country.continent][country.name][:assets] += (membership.updated_balance * percentage / 100).to_f unless investment_asset.asset_type == 'liability'
          balance[country.continent][country.name][:liabilities] += (membership.updated_balance * percentage / 100).to_f if investment_asset.asset_type == 'liability'
          total = investment_asset.asset_type == 'liability' ? (-1 * membership.updated_balance * percentage / 100).to_f : (membership.updated_balance * percentage / 100).to_f
          balance[country.continent][country.name][:total] ||= 0
          balance[country.continent][country.name][:total] += total
        end
      end
    end
    balance
  end
  
  def top_investment_assets
    eligible_asset_types = [
      'fixed_income',
      'variable_income',
      'alternative_asset',
      'balanced_asset',
      'structured_asset',
      'forward_asset',
      'pension_fund',
      'money_market'
    ]
  
    def currency_conversion_rates
      {
        'USD' => DollarPrice.step_business_day,
        'EUR' => EuroPrice.step_business_day,
        'UF' => UfPrice.step_business_day,
        'MXN' => MxnPrice.step_business_day,
        'COP' => CopPrice.step_business_day,
        'CRC' => CrcPrice.step_business_day
      }
    end
  
    def convert_to_clp(amount, currency)
      return amount if currency == 'CLP'
      conversion_rate = currency_conversion_rates[currency]
      amount * conversion_rate
    end
  
    balance = []
    memberships.each do |membership|
      asset = membership.investment_asset
      currency = asset.currency
      next unless eligible_asset_types.include?(asset.asset_type)
  
      asset_id = asset.asset_id
      asset_name = asset.name
      updated_balance = membership.amount_updated_balance || BigDecimal('0')
      converted_amount = convert_to_clp(updated_balance, currency)
      balance_item = balance.find { |item| item[:asset_id] == asset_id }
  
      if balance_item
        balance_item[:amount] += converted_amount
      else
        balance << { asset_id: asset_id, asset_name: asset_name, amount: converted_amount }
      end
    end
  
    top_ten_balances = balance.sort_by { |item| -item[:amount] }.first(10)
    top_ten_balances
  end
  

  def balance_by_institution
    accounts = relation_accounts
    balance = {}
    accounts.each do |account|
      if account.account_type == 'investment' # faltan los demas pension, bienes, etc
        bank_name = Bank.find(account.bank_id).name
        updated_balance = account.updated_balance || BigDecimal('0') # Asegurarse de que updated_balance no sea nil
        if balance.key?(bank_name)
          balance[bank_name] += updated_balance
        else
          balance[bank_name] = updated_balance
        end
      end
    end
    balance
  end
  def balance_by_sustainability
    balances = {}
    sorted_balances = {}
    accounts = relation_accounts
    accounts.each do |account|
      account.sub_accounts.each do |sub_account|
        sub_account.memberships.each do |membership|
          rating = membership.investment_asset.sustainability["global_rating"]
          label = membership.investment_asset.sustainability["label"]
          balances[label] ||= []
          asset_id = membership.investment_asset.asset_id
          balances[label] << { rating: rating, asset_id: asset_id }
        end
      end
    end
  
    balances.each do |label, assets|
      unless label.empty?
        sorted_assets = assets.sort_by { |asset| asset[:rating] }
        sorted_balances[label] = sorted_assets
      end
    end

    sorted_balances
  end
  def investments_distribution
    accounts = relation_accounts
    balance = { total: 0 }
    accounts.each do |account|
      balance[:total] += account.balance_distribution('investments')
      investments_balance = account.investments_balance
      investments_balance.keys.each do |type|
        balance[type] ||= {}
        balance[type][:CLP] ||= 0
        balance[type][:USD] ||= 0
        balance[type][:EUR] ||= 0
        balance[type][:UF] ||= 0
        balance[type][:MXN] ||= 0
        balance[type][:COP] ||= 0
        balance[type][:CRC] ||= 0
        balance[type][:CLP] += investments_balance[type].to_f 
        balance[type][:USD] += investments_balance[type].to_f / dollar
        balance[type][:EUR] += investments_balance[type].to_f / euro
        balance[type][:UF] += investments_balance[type].to_f / uf
        balance[type][:MXN] += investments_balance[type].to_f / mxn
        balance[type][:COP] += investments_balance[type].to_f / cop
        balance[type][:CRC] += investments_balance[type].to_f / crc
      end
    end
    balance
  end

  def vendor
    advisers&.first&.supervisors&.first&.vendor
  end
  
  private

  def dollar 
    dollar = DollarPrice.step_business_day
  end

  def euro
    euro = EuroPrice.step_business_day
  end

  def uf
    uf = UfPrice.step_business_day
  end

  def mxn
    mxn = MxnPrice.step_business_day
  end
  def cop
    cop = CopPrice.step_business_day
  end
  def crc
    crc = CrcPrice.step_business_day
  end


  def self.get_vendor_vars rel
    default_vendor_vars = {
      bank_footer_text: 'B3B3B3',
      document_body_text: '515151',
      titles_text:'293755',
      table_lastrow_currency_text: '4F52FF',
      table_text: '6D778A',
      table_border: 'AAABFF',
      background_lastrow: 'F4F5F7',
      background_main_lastrow: 'E1E2FF',
      logo: 'logo-valuelist.png'
    }

    begin
      vendor = Vendor.where("replace(replace(lower(name), ' ', ''), '-', '') = '#{$VENDOR}'").first
    rescue => e
      return default_vendor_vars
    end
    
    if !vendor.nil? && vendor.vars != '' then
      default_vendor_vars[:bank_footer_text] = vendor.json_vars['bank_footer_text']
      default_vendor_vars[:document_body_text] = vendor.json_vars['document_body_text']
      default_vendor_vars[:titles_text] = vendor.json_vars['titles_text']
      default_vendor_vars[:table_lastrow_currency_text] = vendor.json_vars['table_lastrow_currency_text']
      default_vendor_vars[:table_text] = vendor.json_vars['table_text']
      default_vendor_vars[:table_border] = vendor.json_vars['table_border']
      default_vendor_vars[:background_lastrow] = vendor.json_vars['background_lastrow']
      default_vendor_vars[:background_main_lastrow] = vendor.json_vars['background_main_lastrow']
      default_vendor_vars[:logo] = vendor.json_vars['logo']
    end

    return default_vendor_vars
  end

  def account_name_criteria_for_currency_total
    'relation_total_wallet'
  end

  def rut_number
    rut_clean[0...-1]
  end

  def rut_dv
    rut_clean[-1..-1]
  end

  def rut_clean
    rut.delete(' ').delete('.').delete('-')
  end

  def self.sort_chart_balances input
    hash = {
      state: [],
      profitability: []
    }
    type = input[:type]
    currency = input[:currency]
    if ['CLP', 'USD', 'UF', 'EUR', 'MXN', 'COP', 'CRC'].include? type
      input[:dates].each do |date|
        hash[:state] << "$#{input[:balances][date]["selected"]["balance"][type].to_f.round(2)}"
        hash[:profitability] << "#{(input[:balances][input[:dates].first]["selected"]["balance"][type] / input[:balances][date]["selected"]["balance"][type]).to_f.round(2)}%"
      end
    else
      input[:dates].each do |date|
        hash[:state] << "$#{input[:balances][date]["selected"]["balance"][type][currency].to_f.round(2)}" unless type == 'liability'
        hash[:state] << "$#{input[:balances][date]["selected"]["balance"][type][currency].to_f.round(2) * -1}" if type == 'liability'
        
        first = input[:balances][date]["selected"]["balance"][type][currency] if input[:balances][date]["selected"]["balance"][type][currency] != 0
        hash[:profitability] << "#{(input[:balances][date]["selected"]["balance"][type][currency] / first).to_f.round(2)}%" unless type == 'liability' || input[:balances][date]["selected"]["balance"][type][currency] == 0
        hash[:profitability] << "" if input[:balances][date]["selected"]["balance"][type][currency] == 0
      end
    end
    hash
  end

end
# rubocop:enable Rails/RedundantForeignKey

# == Schema Information
#
# Table name: relations
#
#  id                     :bigint(8)        not null, primary key
#  first_name             :string           not null
#  last_name              :string           not null
#  rut                    :string           not null
#  email                  :string           not null
#  phone                  :string
#  user_id                :bigint(8)        not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  show_wallet            :boolean          default(FALSE)
#  authentication_token   :string(30)
#  active                 :boolean          default(TRUE), not null
#
# Indexes
#
#  index_relations_on_authentication_token  (authentication_token) UNIQUE
#  index_relations_on_email                 (email) UNIQUE
#  index_relations_on_reset_password_token  (reset_password_token) UNIQUE
#  index_relations_on_user_id               (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#


