module Exporter
  class YAML

    def initialize(app:, style: :tree)
      @app    = app
      @style  = style.to_s.downcase
    end

    def export(locale:, phrases:)
      if @style == "xing"
        generate_yaml_for_xing(locale, phrases)
      elsif @style == "flat"
        generate_yaml_flat(locale, phrases)
      elsif @style == "tree"
        generate_yaml(locale, phrases)
      end
    end


    private

    def generate_yaml(locale, phrases)
      translations = {}

      phrases.each do |phrase|
        translations[phrase.key] = phrase.translations.by_locale(locale).first.value
      end

      translations = { locale.key => translations.explode }

      ::YAML.dump translations
    end

    def generate_yaml_for_xing(locale, phrases)
      yaml = ["---"]
      yaml << "#{locale.key}: !omap"

      phrases.each do |phrase|
        yaml << "- #{phrase.key}: ! '#{phrase.translations.by_locale(locale).first.value}'"
      end

      yaml.join("\n")
    end

    def generate_yaml_flat(locale, phrases)
      yaml = ["#{locale.key}:"]

      phrases.each do |phrase|
        yaml << "  #{phrase.key}: ! '#{phrase.translations.by_locale(locale).first.value}'"
      end

      yaml.join("\n")
    end

  end
end
