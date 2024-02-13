class WalletDeposit < ApplicationRecord
  include LedgerizerDocument

  belongs_to :sub_account
  delegate :account, to: :sub_account
  delegate :relation, to: :account
  delegate :user, to: :relation
  delegate :currency, to: :sub_account

  validates :amount, :date, presence: true
  validates :amount, numericality: { greater_than: 0 }
end

# == Schema Information
#
# Table name: wallet_deposits
#
#  id             :bigint(8)        not null, primary key
#  sub_account_id :bigint(8)        not null
#  date           :date
#  amount         :float
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  comment        :string
#
# Indexes
#
#  index_wallet_deposits_on_sub_account_id  (sub_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (sub_account_id => sub_accounts.id)
#
