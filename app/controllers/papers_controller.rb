class PapersController < ApplicationController

  def index
    @result = OwnReality::Query.new.papers(params[:type]).last["hits"]["hits"]
    render :template => "api/papers/index"
  end

  def show
    @result = OwnReality::Query.new.paper(params[:type], params[:id])
    render :json => @result.last
  end

end