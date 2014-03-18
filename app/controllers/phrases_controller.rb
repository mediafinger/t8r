class PhrasesController < BaseController
  respond_to    :html, :json

  # index   inherited from BaseController
  # show    inherited from BaseController
  # new     inherited from BaseController
  # create  inherited from BaseController
  # edit    inherited from BaseController
  # update  inherited from BaseController


  def destroy
    @phrase = @app.phrases.find(params[:id])

    if @phrase.destroy
      flash[:notice] = 'Phrase was successfully deleted.'
    end

    @phrases = @app.phrases
    render :index
  end


  private

  def create_params
    params.require(:phrase).permit(:app_id, :key, :value, :hint, :done)
  end

  def update_params
    params.require(:phrase).permit(:value, :hint, :done)
  end

  def ensure_sort
    @default_sort = { key: :asc }
    super
  end
end
