class Responder < ActiveRecord::Base
  self.primary_key = :name

  alias_attribute :type, :responder_type

  validates :name, presence: true, uniqueness: true
  validates :type, presence: true
  validates :capacity, presence: true, inclusion: { in: 1..5 }

  scope :available, -> { where(emergency_code: nil) }
  scope :on_duty, -> { where(on_duty: true).where('emergency_code is null or emergency_code is not null') }
  scope :available_and_on_duty, -> { where(on_duty: true).where(emergency_code: nil) }
  scope :fire_type, -> { where(type: :fire.capitalize) }
  scope :police_type, -> { where(type: :police.capitalize) }
  scope :medical_type, -> { where(type: :medical.capitalize) }
  scope :by_type, -> (type) { where(type: type.capitalize) }

  # The total capacity of all responders in the city, by type
  # The total capacity of all "available" responders
  # (not currently assigned to an emergency)
  # The total capacity of all "on-duty" responders, including those
  # currently handling emergencies
  # The total capacity of all "available, AND on-duty" responders
  # (the responders currently available to jump into a new emergency)
  def self.find_by_capacity_status(type)
    capacities = []

    by_type = where(type: type.capitalize)
    capacities.push sum_capacities(by_type)
    capacities.push sum_capacities(by_type.available)
    capacities.push sum_capacities(by_type.on_duty)
    capacities.push sum_capacities(by_type.available_and_on_duty)

    capacities
  end

  def self.sum_capacities(responders)
    sum = 0
    responders.each { |r| sum += r.capacity }
    sum
  end

  # wether or not this emergency is
  # covered by responders
  def self.meets_capacity(emergency)
    fire_responders = dispatch_if_cap_not_met emergency, :fire
    police_responders = dispatch_if_cap_not_met emergency, :police
    medical_responders = dispatch_if_cap_not_met emergency, :medical

    meets_capacity = (fire_responders.empty? && police_responders.empty? && medical_responders.empty?)
    meets_capacity
  end

  # finds Responders suited to work on the passed
  # emergency
  def self.dispatch(emergency)
    responders = []

    # get responders for overwhelming severity
    fire_responders = dispatch_if_cap_not_met emergency, :fire
    police_responders = dispatch_if_cap_not_met emergency, :police
    medical_responders = dispatch_if_cap_not_met emergency, :medical

    # get exact responder type for capacity
    dispatch_by_exact_capacity(emergency, fire_responders, :fire) if fire_responders.empty?
    dispatch_by_exact_capacity(emergency, police_responders, :police) if police_responders.empty?
    dispatch_by_exact_capacity(emergency, medical_responders, :medical) if medical_responders.empty?

    dispatch_by_capabilities(emergency, fire_responders, :fire) if fire_responders.empty?
    dispatch_by_capabilities(emergency, police_responders, :police) if police_responders.empty?
    dispatch_by_capabilities(emergency, medical_responders, :medical) if medical_responders.empty?

    responders.concat fire_responders
    responders.concat police_responders
    responders.concat medical_responders

    # make all responders actually work on the emergency
    where(name: responders).update_all(emergency_code: emergency.code)

    responders
  end

  def self.dispatch_by_exact_capacity(emergency, responders_arr, type)
    severity = emergency["#{type}_severity"]
    available_and_on_duty.by_type(type).where(capacity: severity).order(capacity: :desc).each do |r|
      responders_arr.push r.name
    end
  end

  # gets all responders for the type passes if the capacity
  # for the emergency severity is not met
  def self.dispatch_if_cap_not_met(emergency, type)
    responders = available_and_on_duty.by_type(type)
    capacity = sum_capacities responders

    responders = available_and_on_duty.by_type(type).select(:name).map(&:name)
    # if the capacity of all responders of the passed type is lower
    # than the severity of the emergency send all responders else send an empty array
    capacity < emergency["#{type}_severity"] ? responders : []
  end

  # pushes available responders of the specified type to the responders_arr
  def self.dispatch_by_capabilities(emergency, responders_arr, type)
    severity = emergency["#{type}_severity"]
    cap_met = severity
    available_and_on_duty.by_type(type).where("capacity != #{severity}").order(capacity: :desc).each do |r|
      if cap_met > 0
        cap_met -= r.capacity
        responders_arr.push r.name
      end
    end
  end
end
