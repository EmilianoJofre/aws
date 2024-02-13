class RelationHistory < ApplicationRecord
  belongs_to :relation
  validates :time_window, presence: true

  # after_create: :format_by_asset_type 
  
  enum time_window: {
    origin: 0,
    mtd: 1,
    ytd: 2,
    '1m': 3,
    '3m': 4,
    '6m': 5,
    '1y': 6,
    '5y': 7,
    complete: 8
  }

  def format_by_asset_type
    return unless type == 'by_asset_type'

  end
end

# == Schema Information
#
# Table name: relation_histories
#
#  id              :bigint(8)        not null, primary key
#  relation_id     :bigint(8)        not null
#  time_window     :integer
#  wallet_values   :jsonb            not null
#  balances_values :jsonb            not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_relation_histories_on_relation_id  (relation_id)
#
# Foreign Keys
#
#  fk_rails_...  (relation_id => relations.id)
#
