class Emergency < ActiveRecord::Base
  self.primary_key = :code

  validates :code, presence: true, uniqueness: true
  validates :fire_severity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :police_severity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :medical_severity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def self.full_responses
    full = 0

    full += Emergency.find_by_sql(full_response_q(:fire)).count
    full += Emergency.find_by_sql(full_response_q(:police)).count
    full += Emergency.find_by_sql(full_response_q(:medical)).count

    [full, Emergency.count]
  end

  def self.full_response_q(type)
    query = "SELECT * FROM emergencies, responders where emergencies.#{type}_severity >= 0 and "
    query += "responders.responder_type = '#{type.capitalize}' and responders.capacity >= emergencies.#{type}_severity"
    query
  end

  # unassigns all responders attending to this emergency
  def free_responders
    Responder.where(emergency_code: code).update_all(emergency_code: nil)
  end
end
