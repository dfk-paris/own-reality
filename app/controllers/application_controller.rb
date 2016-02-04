class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_action :cors

  protected

    def cors
      origin = request.env['HTTP_ORIGIN']
      domains = [
        'http://dfk-stage.palasthotel.de',
        'https://dfk-paris.org'
      ]
      if origin && origin.start_with?(*domains)
        response.headers['Access-Control-Allow-Origin'] = origin
      end
    end
end
