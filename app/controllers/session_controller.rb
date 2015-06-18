class SessionController < ApplicationController

  def translations
    if I18n.backend.send(:translations) == {}
      I18n.backend.load_translations
    end

    render :json => I18n.backend.send(:translations)
  end

end