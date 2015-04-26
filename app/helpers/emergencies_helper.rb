module EmergenciesHelper

  def jsonbuild_emergency(emergency, json)

    em = {
        code: emergency.code,
        fire_severity: emergency.fire_severity,
        police_severity: emergency.police_severity,
        medical_severity: emergency.medical_severity,
        resolved_at: emergency.resolved_at
    }

    json.emergency em

  end

end
