class ImportController < ApplicationController
  before_filter :ensure_app
  respond_to    :html, :json

  def show
  end

  def upload_yaml
    content = YAML::load(upload_params[:file].read)

    @yaml = Importer::YAML.new(
      app:      App.find(upload_params[:app_id]),
      content:  content,
      options:  options
    )

    # TODO: move to background process
    @yaml.import

    render :yaml, status: :ok
  end

  def upload_obc
    content = upload_params[:file].read

    @obc = Importer::OBC.new(
      app:     App.find(upload_params[:app_id]),
      content: content,
      options: options.merge(set_locale: obc_locale)
    )

    # TODO: move to background process
    @obc.import

    render :obc, status: :ok
  end


  private

  def ensure_app
    @app ||= App.find(params[:app_id])
  end

  def options
    {
      import_translations:  upload_params[:import_translations],
      set_as_verified:      upload_params[:set_as_verified],
      set_as_translated:    upload_params[:set_as_translated],
      use_as_phrase:        upload_params[:use_as_phrase]
    }
  end

  def upload_params
    params.require(:app_id)
    params.require(:file)
    params.require(:import_translations)
    params.require(:set_as_verified)
    params.require(:set_as_translated)
    params.require(:use_as_phrase)

    params
  end

  def obc_locale
    params.require(:set_locale)

    params[:set_locale].to_s.parameterize.underscore.to_sym
  end
end
