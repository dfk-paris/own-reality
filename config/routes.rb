Rails.application.routes.draw do
  
  root :to => "tpl#index"

  defaults :format => "html" do
    match "/query", :to => "tpl#query", :via => :get
  end

  defaults :format => "json" do
    match "api/entities/search", :to => "entities#search", :via => :post
    match "api/entities/lookup", :to => "entities#lookup", :via => :post
    match "api/translations", :to => "session#translations", :via => :get
  end

end
