class Responder < ActiveRecord::Base
  self.primary_key = :name

  alias_attribute :type, :responder_type

  validates :name, :presence => true, :uniqueness => true
  validates :type, :presence => true
  validates :capacity, :presence => true, :inclusion => {in: 1..5}
end
