class ApplicationRecord < ActiveRecord::Base
  include PowerTypes::Observable
  self.abstract_class = true
end
