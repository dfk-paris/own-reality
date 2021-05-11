class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :null_session

  before_action :cors

  protected

    def cors
      response.headers['Access-Control-Allow-Origin'] = '*'
      response.headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
      response.headers['Access-Control-Allow-Headers'] = '*'
      response.headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    end

    def external_request?
      !local_request?
    end

    def local_request?
      request.remote_ip == '127.0.0.1' ||
      request.remote_ip == '::1' ||
      (
        request.remote_ip.match(/^192\.168\.\d{1,3}\.\d{1,3}$/) &&
        request.remote_ip != '192.168.30.1'
      )
    end
end
