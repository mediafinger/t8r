class ImportController < ApplicationController
  before_filter :ensure_app
  respond_to    :html, :json

  def show
  end

  def upload_yaml
    content = YAML::load(upload_params[:file].read)

    @yaml = Importer::YAML.new(
      app:                  App.find(upload_params[:app_id]),
      content:              content,
      import_translations:  upload_params[:import_translations],
      set_as_translated:    upload_params[:set_as_translated]
    ).import

    render :show, status: :ok
  end


  private

  def ensure_app
    @app ||= App.find(params[:app_id])
  end

  def upload_params
    params.require(:app_id)
    params.require(:file)
    params.require(:import_translations)
    params.require(:set_as_translated)

    params
  end
end
