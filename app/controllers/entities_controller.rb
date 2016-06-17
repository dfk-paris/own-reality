class EntitiesController < ApplicationController

  def chronology
    @result = OwnReality::Query.new.search("chronology", 
      "per_page" => params[:per_page],
      "lower" => params[:lower], 
      "upper" => params[:upper],
      "terms" => params[:terms],
      "people" => params[:people_ids],
      "refs" => params[:attribute_ids]
    ).last
    render :template => "api/entities/search"
  end

  def search
    @result = OwnReality::Query.new.search(params['type'],
      "search_type" => params[:search_type],
      "per_page" => params[:per_page],
      "lower" => params[:lower], 
      "upper" => params[:upper],
      "terms" => params[:terms],
      "refs" => params[:attribute_ids],
      'kind_id' => params[:kind_id],
      'klass_id' => params[:klass_id],
      'category_id' => params[:category_id],
      "page" => params[:page],
      'people' => params[:people_ids],
      'journals' => params[:journal_names],
      'year_ranges' => params[:year_ranges],
      'register' => params[:register],
      'locale' => params[:locale],
      'initial' => params[:initial],
      'sort' => params[:sort]
    ).last
    render :template => "api/entities/search"
  end

  def lookup
    response = OwnReality::Query.new.lookup(params[:type], params[:ids]).last
    @records = (response.is_a?(Array) ? response : response['docs'])
    render :template => "api/entities/lookup"
  end

  def show
    @record = OwnReality::Query.new.mget(params[:type], params[:id]).last
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
