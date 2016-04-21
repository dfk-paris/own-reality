class PeopleController < ApplicationController

  def index
    @result = OwnReality::Query.new.people(
      "terms" => params[:terms],
      "per_page" => params[:per_page],
      "page" => params[:page]
    ).last

    render :template => "api/people/index"
  end

end