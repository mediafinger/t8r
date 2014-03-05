class TranslationsController < BaseController
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
    params.require(:translation).permit(:value, :done)
  end

  def ensure_sort
    @default_sort = { done: :asc, updated_at: :asc }
    super
  end
end
