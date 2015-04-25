json.array!(@emergencies) do |emergency|
  jsonbuild_emergency emergency,json
end
