class AppsController < BaseController
  respond_to    :html

  # index   inherited from BaseController
  # show    inherited from BaseController
  # new     inherited from BaseController
  # create  inherited from BaseController
  # edit    inherited from BaseController
  # update  inherited from BaseController

  private

  def create_params
    params.require(:app).permit(:name, :key)
  end

  def update_params
    params.require(:app).permit(:name)
  end

end
