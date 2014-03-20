module Exporter
  class YAML

    def initialize(app:)
      @app = app
    end

    def export(locale:, phrases:, options: {})
      @only_translated = options[:only_translated] == "true"

      if options[:style] == "xing"
        generate_yaml_for_xing(locale, phrases)
      elsif options[:style] == "flat"
        generate_yaml_flat(locale, phrases)
      elsif options[:style] == "tree"
        generate_yaml(locale, phrases)
      end
    end


    private

    def generate_yaml(locale, phrases)
      translations = {}

      phrases.each do |phrase|
        translation = get_translation(phrase, locale)

        if translation.present?
          translations[phrase.key] = translation.value
        end
      end

      translations = { locale.key => translations.explode }

      ::YAML.dump translations
    end

    def generate_yaml_for_xing(locale, phrases)
      yaml = ["---"]
      yaml << "#{locale.key}: !omap"

      phrases.each do |phrase|
        translation = get_translation(phrase, locale)

        if translation.present?
          yaml << "- #{phrase.key}: ! '#{translation.value}'"
        end
      end

      yaml.join("\n")
    end

    def generate_yaml_flat(locale, phrases)
      yaml = ["#{locale.key}:"]

      phrases.each do |phrase|
        translation = get_translation(phrase, locale)

        puts "TRANSLATION: translation.inspect"

        if translation.present?
          yaml << "  #{phrase.key}: ! '#{translation.value}'"
        end
      end

      yaml.join("\n")
    end

    def get_translation(phrase, locale)
      if @only_translated
        phrase.translations.by_locale(locale).translated.first
      else
        phrase.translations.by_locale(locale).first
      end
    end

  end
end
