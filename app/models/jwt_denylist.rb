class JwtDenylist < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist

  self.table_name = 'jwt_denylist'
end

# == Schema Information
#
# Table name: jwt_denylist
#
#  id  :bigint(8)        not null, primary key
#  jti :string           not null
#  exp :datetime         not null
#
# Indexes
#
#  index_jwt_denylist_on_jti  (jti)
#
