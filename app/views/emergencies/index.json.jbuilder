json.emergencies do
  json.array!(@emergencies) do |emergency|
    json.extract! emergency, :code, :fire_severity, :police_severity, :medical_severity
  end
end
