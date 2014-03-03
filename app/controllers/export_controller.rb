class ExportController < ApplicationController
  before_filter :ensure_app
  respond_to    :html, :json

  def show
    @locales ||= @app.locales.order(key: :asc).pluck(:key, :id)
  end

  def download_yaml
    @app     = App.find(download_params[:app_id])
    @locale  = Locale.find(download_params[:locale])
    @phrases = @locale.phrases.default_order

    @yaml = generate_yaml(@locale, @phrases)
    # @yaml = generate_yaml_for_xing(@locale, @phrases)

    send_data @yaml,
      filename: "#{@locale.key.to_s}.yml",
      :type=> "text/yml; charset=utf-8"
  end

  def generate_yaml(locale, phrases)
    yaml = ["#{locale.key}:"]

    phrases.each do |phrase|
      yaml << "  #{phrase.key}: ! '#{phrase.translations.by_locale(locale).first.value}'"
    end

    yaml.join("\n")
  end

  def generate_yaml_for_xing(locale, phrases)
    yaml = ["---"]
    yaml << "#{locale.key}: !omap"

    phrases.each do |phrase|
      yaml << "- #{phrase.key}: ! '#{phrase.translations.by_locale(locale).first.value}'"
    end

    yaml.join("\n")
  end


  private

  def ensure_app
    @app ||= App.find(params[:app_id])
  end

  def download_params
    params.require(:app_id)
    params.require(:locale)
    # params.require(:file)
    # params.require(:import_translations)
    # params.require(:set_as_translated)

    params
  end
end
