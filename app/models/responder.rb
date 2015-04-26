class Responder < ActiveRecord::Base
  self.primary_key = :name

  alias_attribute :type, :responder_type

end
