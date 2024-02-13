class CrcPrice < ApplicationRecord
    validates :price, :date, presence: true
    validates :date, uniqueness: true
    def self.previous_business_day(date = Date.current)
      previous_date = 1.business_day.before(date)
      find_by(date: previous_date)&.price || previous_business_day(previous_date)
    end
  
    def self.step_business_day(step = 0)
      date = Date.current - step.days
      price = find_by(date: date)&.price
      # if not found, returns last record by date
      price ||= CrcPrice.order(:date).last.price 
      price
    end
  end
  
  # == Schema Information
  #
  # Table name: crc_prices
  #
  #  id         :bigint(8)        not null, primary key
  #  price      :float            not null
  #  date       :datetime         not null
  #  created_at :datetime         not null
  #  updated_at :datetime         not null
  #
  # Indexes
  #
  #  index_crc_prices_on_date  (date) UNIQUE
  #
  