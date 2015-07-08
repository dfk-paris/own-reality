Rails.application.routes.draw do
  
  root :to => "tpl#index"

  defaults :format => "html" do
    match "/query", :to => "tpl#query", :via => :get
    match "/synthese", :to => "tpl#synthese", :via => :get
  end

  defaults :format => "json" do
    match "api/entities/search", :to => "entities#search", :via => :post
    match "api/entities/lookup", :to => "entities#lookup", :via => :post
    match "api/entities/:id", :to => "entities#show", :via => :post
    match "/api/entities/download/:hash.:format", :to => "entities#download", :via => :get
    match "api/translations", :to => "session#translations", :via => :get
    match "api/misc", :to => "misc#index", :via => :get
  end

end
