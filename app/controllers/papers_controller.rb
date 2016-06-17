class PapersController < ApplicationController

  def index
    @result = OwnReality::Query.new.papers(params[:type], "per_page" => 1000).last["hits"]["hits"]
    render :template => "api/papers/index"
  end

end