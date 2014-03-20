module Exporter
  class OBC

    def initialize(app:)
      @app = app
    end

    def export(locale:, phrases:, options: {})
      @only_translated = options[:only_translated] == "true"

      generate_obc(locale, phrases)
    end


    private

    def generate_obc(locale, phrases)
      translations = []

      phrases.each do |phrase|
        translation = get_translation(phrase, locale)

        if translation.present?
          translations << "#{phrase.key}\t#{translation.value}"
        end
      end

      translations.join("\n")
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
