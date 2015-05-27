class TplController < ApplicationController

  layout false

  def index
    render :layout => "application", :text => ""
  end

  def query
    
  end 

end