module Exporter
  class OBC

    def initialize(app:)
      @app = app
    end

    def export(locale:, phrases:)
      generate_obc(locale, phrases)
    end


    private

    def generate_obc(locale, phrases)
      translations = []

      phrases.each do |phrase|
        translation = phrase.translations.by_locale(locale).translated.first

        if translation.present?
          translations << "#{phrase.key}\t#{translation.value}"
        end
      end

      translations.join("\n")
    end

  end
end
