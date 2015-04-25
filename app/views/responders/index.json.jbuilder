json.array!(@responders) do |responder|
  jsonbuild_responder responder, json
end
