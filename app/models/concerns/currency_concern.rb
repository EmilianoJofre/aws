module CurrencyConcern
  extend ActiveSupport::Concern

  included do
    extend Enumerize
    enumerize :currency, in: { CLP: 0, USD: 1, EUR: 2, UF: 3, MXN: 4, COP: 5, CRC: 6 }
  end
end
