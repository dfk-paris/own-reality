class EntitiesController < ApplicationController

  def search
    @result = OwnReality::Query.new.search(params[:criteria]).last
    render :template => "api/entities/search"
  end

  def lookup
    response = OwnReality::Query.new.lookup("attribs", params[:ids]).last
    @records = (response.is_a?(Array) ? response : response['docs'])
    render :template => "api/entities/lookup"
  end

end