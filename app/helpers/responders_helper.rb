module RespondersHelper

  # Todo: extract to a reusable extract
  def jsonbuild_responder(responder, json)

    resp = {
        emergency_code: responder.emergency_code,
        type: responder.responder_type,
        name: responder.name,
        capacity: responder.capacity,
        on_duty: responder.on_duty
    }
    json.responder resp

  end

end
