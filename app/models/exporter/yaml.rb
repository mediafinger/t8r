module Exporter
  class YAML

    def initialize(app:, for_xing: false)
      @app = app
      @for_xing = for_xing
    end

    def export(locale:, phrases:)
      if @for_xing
        generate_yaml_for_xing(locale, phrases)
      else
        generate_yaml(locale, phrases)
      end
    end


    private

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
  end
end
