class Responder < ActiveRecord::Base
  self.primary_key = :name

  alias_attribute :type, :responder_type

  validates :name, :presence => true, :uniqueness => true
  validates :type, :presence => true
  validates :capacity, :presence => true, :inclusion => {in: 1..5}

  scope :available, -> { where(emergency_code: nil) }
  scope :on_duty, -> { where(on_duty: true).where('emergency_code is null or emergency_code is not null') }
  scope :available_and_on_duty, -> { where(on_duty: true).where(emergency_code: nil) }

  # The total capacity of all responders in the city, by type
  # The total capacity of all "available" responders (not currently assigned to an emergency)
  # The total capacity of all "on-duty" responders, including those currently handling emergencies
  # The total capacity of all "available, AND on-duty" responders (the responders currently available to jump into a new emergency)
  def self.find_by_capacity_status type
    capacities = []

    by_type = self.where(type: type.capitalize)
    capacities.push sum_capacities(by_type)
    capacities.push sum_capacities(by_type.available)
    capacities.push sum_capacities(by_type.on_duty)
    capacities.push sum_capacities(by_type.available_and_on_duty)

    capacities
  end

  def self.sum_capacities(responders)
    sum = 0
    responders.each { |r| sum+= r.capacity }
    sum
  end

  # finds Responders suited to work on the passed
  # emergency
  def self.dispatch emergency

    # fire_cap = emergency.fire_severity
    # police_cap = emergency.police_severity
    # medical_cap = emergency.medical_severity
    #
    #
    # fire_responders = self.where('capacity' >= fire_cap)
    # police_responders =
    # medical_responders =

  end

end
