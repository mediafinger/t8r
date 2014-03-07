class LocalesController < BaseController
  respond_to    :html, :json

  # index   inherited from BaseController
  # show    inherited from BaseController
  # new     inherited from BaseController
  # create  inherited from BaseController
  # edit    inherited from BaseController
  # update  inherited from BaseController


  private

  def create_params
    params.require(:locale).permit(:app_id, :name, :key)
  end

  def update_params
    params.require(:locale).permit(:name)
  end

  def ensure_sort
    @default_sort = { name: :asc }
    super
  end
end
