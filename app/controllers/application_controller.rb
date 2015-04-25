class ApplicationController < ActionController::Base

  # Renders 404.html.json for any resource not foudn
  def page_not_found
    render json: {:message => 'page not found'}.to_json, status: 404
  end

  # Wraps a message response with 'message' object
  def wrap_msg_response(to_wrap)
    wrap_object 'message', to_wrap
  end

  # Makes the object 'to_wrap' a child of a variable
  # named with the 'wrapper_name'
  def wrap_object(wrapper_name, to_wrap)
    {wrapper_name => to_wrap}
  end

end