module RespondersHelper

  def jsonbuild_responder(responder, json, wrap)

    resp = {
        emergency_code: responder.emergency_code,
        type: responder.type,
        name: responder.name,
        capacity: responder.capacity,
        on_duty: responder.on_duty ? true : false
    }

    if wrap
      json.responder resp
    else
      json.(resp, :emergency_code, :type, :name, :capacity, :on_duty)
    end

  end

end

