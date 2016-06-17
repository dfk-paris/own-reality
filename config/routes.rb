Rails.application.routes.draw do
  
  # handle CORS preflight requests
  match '(*all)', to: proc{[200, {}, ['']]}, via: :options

  defaults :format => "json" do
    match "api/chronology", :to => "entities#chronology", :via => :post
    match "api/papers/:type", :to => "papers#index", :via => :get
    match "api/items/:type/:id", :to => "entities#show", :via => :get
    match "api/entities/search", :to => "entities#search", :via => :post
    match "api/entities/lookup", :to => "entities#lookup", :via => :post
    match "api/entities/:id", :to => "entities#show", :via => :post
    match "api/entities/download/:hash.:format", :to => "entities#download", :via => :get
    match "api/translations", :to => "session#translations", :via => :get
    match "api/misc", :to => "misc#index", :via => :get
    match 'api/people', to: 'people#index', via: :post
  end

end
