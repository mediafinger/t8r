class TranslationsController < BaseController
  before_filter :ensure_locales, only: [:index]
  respond_to    :html, :json

  # index   inherited from BaseController
  # show    inherited from BaseController
  # new     inherited from BaseController
  # create  inherited from BaseController
  # edit    inherited from BaseController
  # update  inherited from BaseController


  private

  def create_params
    params.require(:translation).permit(:locale_id, :phrase_id)
  end

  def update_params
    params.require(:translation).permit(:value, :done, :hidden)
  end

  def ensure_sort
    @default_sort = { done: :asc, updated_at: :asc }
    super
  end

  def ensure_locales
    @locales ||= @app.locales.order(key: :asc).pluck(:key)
  end
end
