class RelationFile < ApplicationRecord
  before_validation :infer_relations
  belongs_to :relation
  belongs_to :account, optional: true
  belongs_to :sub_account, optional: true
  belongs_to :bank, optional: true

  enum document_type: {
    bank_statement: 0,
    bank_report: 1,
    deed: 2,
    afp_statement: 3
  }

  include RelationDocumentUploader::Attachment(:file)

  validate :account_from_relation,
           :account_from_bank,
           :sub_account_from_account

  private

  def account_from_relation
    if account.present? && account.relation != relation
      errors.add(:account, "AccountRelationError")
    end
  end

  def account_from_bank
    if account.present? && account.bank != bank
      errors.add(:account, "AccountBankError")
    end
  end

  def sub_account_from_account
    if sub_account.present? && sub_account.account != account
      errors.add(:account, "SubAccountAccountError")
    end
  end

  def infer_relations
    if sub_account
      self.account ||= sub_account.account
      self.bank ||= account.bank
    elsif account
      self.bank ||= account.bank
    end
  end
end

# == Schema Information
#
# Table name: relation_files
#
#  id             :bigint(8)        not null, primary key
#  relation_id    :bigint(8)        not null
#  account_id     :bigint(8)
#  sub_account_id :bigint(8)
#  bank_id        :bigint(8)
#  name           :string
#  date           :date
#  document_type  :integer
#  file_data      :jsonb
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_relation_files_on_account_id      (account_id)
#  index_relation_files_on_bank_id         (bank_id)
#  index_relation_files_on_relation_id     (relation_id)
#  index_relation_files_on_sub_account_id  (sub_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (bank_id => banks.id)
#  fk_rails_...  (relation_id => relations.id)
#  fk_rails_...  (sub_account_id => sub_accounts.id)
#
