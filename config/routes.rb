Rails.application.routes.draw do
  
  root :to => "tpl#index"

  match "api/entities/search", :to => "entities#search", :via => :post
  match "api/entities/lookup", :to => "entities#lookup", :via => :post

end
