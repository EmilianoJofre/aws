class Api::V1::CurrenciesController < Api::V1::BaseController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  before_action :authenticate_api_key
  
  def index
    data = {
      USD: dollar,
      EUR: euro,
      UF: uf,
      MXN:mxn,
      COP:cop,
      CRC:crc
    }
    respond_with data
  end

  def dollar
    DollarPrice.step_business_day
  end

  def mxn
    MxnPrice.step_business_day
  end
  
  def euro
    EuroPrice.step_business_day
  end

  def uf
    UfPrice.step_business_day
  end

  def crc
    CrcPrice.step_business_day
  end

  def cop
    CopPrice.step_business_day
  end
end
