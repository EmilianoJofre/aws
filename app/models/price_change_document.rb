class PriceChangeDocument < ApplicationRecord
  include LedgerizerDocument

  belongs_to :price_change
  belongs_to :membership
  
  # Volver a implementar callbacks cuando se saque el ledgerizer
  # after_save :update_membership

  # def update_membership
  #   membership.update(updated_balance: membership.balance[:CLP], status: 'updated')
  # end
end

# == Schema Information
#
# Table name: price_change_documents
#
#  id              :bigint(8)        not null, primary key
#  price_change_id :bigint(8)        not null
#  membership_id   :bigint(8)        not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_price_change_documents_on_membership_id    (membership_id)
#  index_price_change_documents_on_price_change_id  (price_change_id)
#
# Foreign Keys
#
#  fk_rails_...  (membership_id => memberships.id)
#  fk_rails_...  (price_change_id => price_changes.id)
#
