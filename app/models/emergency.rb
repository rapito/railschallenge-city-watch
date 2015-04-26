class Emergency < ActiveRecord::Base
  self.primary_key = :code

  validates :code, presence: true, uniqueness: true
  validates :fire_severity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :police_severity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :medical_severity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def self.full_responses
    full = 0
    full += Emergency.find_by_sql("SELECT * FROM emergencies, responders where emergencies.fire_severity >= 0 and responders.responder_type = 'Fire' and responders.capacity >= emergencies.fire_severity").count
    full += Emergency.find_by_sql("SELECT * FROM emergencies, responders where emergencies.police_severity >= 0 and responders.responder_type = 'Police' and responders.capacity >= emergencies.police_severity").count
    full += Emergency.find_by_sql("SELECT * FROM emergencies, responders where emergencies.medical_severity >= 0 and responders.responder_type = 'Medical' and responders.capacity >= emergencies.medical_severity").count

    [full, Emergency.count]
  end
end
