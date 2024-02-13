# rubocop:disable Layout/LineLength, Style/RedundantSelf, Rails/RedundantForeignKey
class DemoRelationFile < ApplicationRecord
  self.table_name = 'relation_files'

  belongs_to :relation, class_name: "::DemoRelation", foreign_key: :relation_id
  belongs_to :account, class_name: "::DemoAccount", foreign_key: :account_id, optional: true
  belongs_to :sub_account, class_name: "::DemoSubAccount", foreign_key: :sub_account_id, optional: true
  belongs_to :bank, class_name: "::DemoBank", foreign_key: :bank_id, optional: true

  belongs_to :demo_relation, class_name: "::DemoRelation", foreign_key: :relation_id
  belongs_to :demo_account, class_name: "::DemoAccount", foreign_key: :account_id, optional: true
  belongs_to :demo_sub_account, class_name: "::DemoSubAccount", foreign_key: :sub_account_id, optional: true
  belongs_to :demo_bank, class_name: "::DemoBank", foreign_key: :bank_id, optional: true

  enum document_type: {
    bank_statement: 0,
    bank_report: 1,
    deed: 2,
    afp_statement: 3
  }

  def name
    if document_type == "bank_report"
      "Reporte_" + (!self.date.nil? ? self.date.strftime("%b%y") : self.created_at.strftime("%b%y"))
    elsif document_type == "deed"
      "Escritura" + (!self.date.nil? ? self.date.strftime("%b%y") : self.created_at.strftime("%b%y"))
    else
      if self.account.nil? || self.bank.nil?
        "Archivo_" + (!self.date.nil? ? self.date.strftime("%b%y") : self.created_at.strftime("%b%y"))
      else
        self.account.name.truncate_words(1, omission: '').parameterize.underscore.camelize + "_" + self.bank.name.truncate_words(1, omission: '') + "_" + self.date.strftime("%b%y")
      end
    end
  end

  def file_name
    demo_filename
  end

  def file_url
    demo_filename
  end

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

  def demo_filename
    base = "/demo_documents/"

    case document_type
    when "bank_statement"
      base + "cartola.pdf"
    when "bank_report"
      base + "reporte.pdf"
    when "deed"
      base + "escritura.pdf"
    end
  end
end
# rubocop:enable Layout/LineLength, Style/RedundantSelf, Rails/RedundantForeignKey

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
