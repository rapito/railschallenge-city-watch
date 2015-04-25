module EmergenciesHelper

  def jsonbuild_emergency(emergency, json)

    json.code = emergency.code
    json.fire_severity = emergency.fire_severity
    json.police_severity = emergency.police_severity
    json.medical_severity = emergency.medical_severity

  end

end
