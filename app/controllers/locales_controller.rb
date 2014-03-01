class LocalesController < BaseController
  before_filter :ensure_app

  respond_to    :html, :json

  # index   inherited from BaseController
  # show    inherited from BaseController
  # new     inherited from BaseController
  # create  inherited from BaseController
  # edit    inherited from BaseController
  # update  inherited from BaseController

  def index
    @order = { name: :asc }
    super
  end

  private

  def create_params
    params.require(:locale).permit(:app_id, :name, :key)
  end

  def update_params
    params.require(:locale).permit(:name)
  end

  def ensure_app
    @app ||= App.find(params[:app_id])
  end
end
