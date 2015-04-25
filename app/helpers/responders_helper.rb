module RespondersHelper

  def jsonbuild_responder(responder, json)

    json.emergency_code = responder.emergency_code
    json.type = responder.responder_type
    json.name = responder.name
    json.capacity = responder.capacity
    json.on_duty = responder.on_duty

  end

end
