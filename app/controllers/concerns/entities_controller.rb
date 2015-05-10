class EntitiesController < ApplicationController

  def search
    @result = OwnReality::Query.new.search(params[:criteria]).last
    render :template => "api/entities/search"
  end

  def lookup
    @records = OwnReality::Query.new.lookup("attribs", params[:ids]).last['docs']
    render :template => "api/entities/lookup"
  end

end