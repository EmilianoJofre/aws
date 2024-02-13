class AdviserRelation < ApplicationRecord
  belongs_to :adviser
  belongs_to :relation
end

# == Schema Information
#
# Table name: adviser_relations
#
#  id          :bigint(8)        not null, primary key
#  adviser_id  :bigint(8)        not null
#  relation_id :bigint(8)        not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_adviser_relations_on_adviser_id   (adviser_id)
#  index_adviser_relations_on_relation_id  (relation_id)
#
# Foreign Keys
#
#  fk_rails_...  (adviser_id => advisers.id)
#  fk_rails_...  (relation_id => relations.id)
#
