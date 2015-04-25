class ApplicationController < ActionController::Base

  # Renders 404.html.json for any resource not foudn
  def page_not_found
    render json: {:message => 'page not found'}.to_json, status: 404
  end

end