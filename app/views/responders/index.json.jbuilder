json.array!(@responders) do |responder|
  json.extract! responder, :id, :emergency_code, :responder_type, :name, :capacity, :on_duty
  json.url responder_url(responder, format: :json)
end
