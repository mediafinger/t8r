class TranslationsController < BaseController
  before_filter :ensure_app
  before_filter :ensure_locale
  before_filter :ensure_phrase
  before_filter :ensure_locales
  before_filter :ensure_phrases

  respond_to    :html, :json


  # index   inherited from BaseController
  # show    inherited from BaseController
  # new     inherited from BaseController
  # create  inherited from BaseController
  # edit    inherited from BaseController
  # update  inherited from BaseController
  # destroy inherited from BaseController

  private

  def create_params
    params.require(:translation).permit(:locale_id, :phrase_id)
  end

  def update_params
    params.require(:translation).permit(:value, :done)
  end

  def ensure_app
    @app ||= App.find(params[:app_id])
  end

  def ensure_locale
    @locale ||= Locale.find(params[:locale_id])
  end

  def ensure_locales
    @locales ||= Locale.all
  end

  def ensure_phrase
    @phrase ||= Phrase.find(params[:phrase_id])
  end

  def ensure_phrases
    @phrases ||= Phrase.all
  end

end
