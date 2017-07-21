class EntitiesController < ApplicationController

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
      'sort' => params[:sort],
      'exclude' => params[:exclude]
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
    @record['external_request'] = external_request?
    render :json => @record
  end

  def download
    hash = params[:hash].gsub(/[\\\/]/, '')
    path = "#{Rails.root}/public/files/#{hash}/original.pdf"
    send_data(File.read(path),
      :filename => params[:fn],
      :disposition => "attachment",
      :type => "application/pdf"
    )
  end

end
