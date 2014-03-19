class ExportController < ApplicationController
  before_filter :ensure_app
  respond_to    :html, :json

  def show
    respond_to do |format|
      format.html { @locales ||= @app.locales.order(key: :asc).pluck(:key, :id) }

      format.json do
        if json_locale.present?
          translations = @app.translations.by_locale(json_locale).translated
          render json: translations, each_serializer: TranslationsSerializer, root: false
        else
          render json: "Locale #{params[:locale]} does not exist for this app [T]"
        end
      end
    end
  end

  def download
    locale   = Locale.find(download_params[:locale])
    phrases  = locale.phrases.order({ key: :asc })

    if download_params[:format] == "yaml"
      send_yaml(locale, phrases)
    elsif download_params[:format] == "obc"
      send_obc(locale, phrases)
    end
  end


  private

  def send_yaml(locale, phrases)
    exporter = Exporter::YAML.new(app: @app)
    @yaml    = exporter.export(
      locale: locale,
      phrases: phrases,
      options: { only_translated: download_params[:only_translated], style: yaml_style }
    )

    send_data @yaml, filename: "#{locale.key.to_s}.yml", :type=> "text/yml; charset=utf-8"
  end

  def send_obc(locale, phrases)
    exporter = Exporter::OBC.new(app: @app)
    @obc     = exporter.export(
      locale: locale,
      phrases: phrases,
      options: { only_translated: download_params[:only_translated] }
    )

    send_data @obc, filename: "#{locale.key.to_s}.resource.txt", :type=> "text/txt; charset=utf-8"
  end

  def ensure_app
    @app ||= App.find(params[:app_id])
  end

  def download_params
    params.require(:app_id)
    params.require(:locale)
    params.require(:format)
    params.require(:only_translated)

    params
  end

  def yaml_style
    params.require(:style)

    params[:style].to_s.downcase
  end

  def json_locale
    params.require(:locale)

    @app.locales.where(key: params[:locale]).first
  end

end
