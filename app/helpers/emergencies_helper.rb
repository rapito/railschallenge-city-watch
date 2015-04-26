module EmergenciesHelper
  def jsonbuild_emergency(emergency, responders, _cap_met, json)
    em = {

        code: emergency.code,
        fire_severity: emergency.fire_severity,
        police_severity: emergency.police_severity,
        medical_severity: emergency.medical_severity,
        resolved_at: emergency.resolved_at,
        responders: responders
    }

    em[:full_response] = "#{responders.count} responders has been dispatched" if responders
    # em.delete :full_response unless cap_met

    json.emergency em
  end
end
