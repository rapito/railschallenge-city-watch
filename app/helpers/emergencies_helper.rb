module EmergenciesHelper

  def jsonbuild_emergency(emergency, json)

    em = {
        code: emergency.code,
        fire_severity: emergency.fire_severity,
        police_severity: emergency.police_severity,
        medical_severity: emergency.medical_severity
    }
    
    json.emergency em

  end

end
