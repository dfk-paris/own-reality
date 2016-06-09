Rails.application.routes.draw do
  
  root :to => "tpl#index"

  match 'dfk', :to => 'tpl#dfk', :via => :get

  defaults :format => "html" do
    match "/home", :to => "tpl#home", :via => :get
    match "/chronology", :to => "tpl#chronology", :via => :get
    match "/query", :to => "tpl#query", :via => :get
    match "/papers/:type", :to => "tpl#papers", :via => :get
    match "/paper", :to => "tpl#paper", :via => :get
  end

  defaults :format => "json" do
    match "api/chronology", :to => "entities#chronology", :via => [:post, :get]
    match "api/papers/:type", :to => "papers#index", :via => :get
    match "api/items/:type/:id", :to => "entities#show", :via => :get
    match "api/entities/search", :to => "entities#search", :via => [:post, :get]
    match "api/entities/lookup", :to => "entities#lookup", :via => [:post, :get]
    match "api/entities/:id", :to => "entities#show", :via => [:post, :get]
    match "api/entities/download/:hash.:format", :to => "entities#download", :via => :get
    match "api/translations", :to => "session#translations", :via => :get
    match "api/misc", :to => "misc#index", :via => :get
    match 'api/people', to: 'people#index', via: [:post, :get]
  end

end
