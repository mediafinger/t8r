class ExportController < ApplicationController
  before_filter :ensure_app
  respond_to    :html, :json

  def show
    @locales ||= @app.locales.order(key: :asc).pluck(:key, :id)
  end

  def download_yaml
    locale   = Locale.find(download_params[:locale])
    phrases  = locale.phrases.order({ key: :asc })

    exporter = Exporter::YAML.new(app: @app, style: :tree)
    @yaml    = exporter.export(locale: locale, phrases: phrases)

    send_data @yaml, filename: "#{locale.key.to_s}.yml", :type=> "text/yml; charset=utf-8"
  end


  private

  def ensure_app
    @app ||= App.find(params[:app_id])
  end

  def download_params
    params.require(:app_id)
    params.require(:locale)

    params
  end
end
