class EntitiesController < ApplicationController

  def chronology
    p params[:refs]
    @result = OwnReality::Query.new.search("chronology", 
      "per_page" => 100,
      "lower" => params[:lower], 
      "upper" => params[:upper],
      "terms" => params[:terms],
      "refs" => params[:refs],
      "category_id" => params[:category_id]
    ).last
    render :template => "api/entities/search"
  end

  def search
    @result = OwnReality::Query.new.search("sources", params[:criteria]).last
    render :template => "api/entities/search"
  end

  def lookup
    response = OwnReality::Query.new.lookup("attribs", params[:ids]).last
    @records = (response.is_a?(Array) ? response : response['docs'])
    render :template => "api/entities/lookup"
  end

  def show
    @record = OwnReality::Query.new.paper("sources", params[:id]).last
    render :json => @record
  end

  def download
    hash = params[:hash].gsub(/[\\\/]/, '')
    path = "#{Rails.root}/public/files/#{hash}/original.pdf"
    send_data(File.read(path),
      :filename => "article.pdf",
      :disposition => "attachment",
      :type => "application/pdf"
    )
  end

end
