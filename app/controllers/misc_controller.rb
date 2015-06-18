class MiscController < ApplicationController

  def index
    render :json => OwnReality::Query.new.config
  end

end