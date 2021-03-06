module Importer
  class OBC

    # Matchers for the lines of the imported file
    COMMENT   = /^#.*/
    KEY_VALUE = /^(\w+)\s+(.*)/
    TEXT      = /^\s+(.*)/

    def initialize(app:, content:, options: {})
      @app                 = app
      @obc                 = content

      @set_locale          = options[:set_locale]

      @use_as_phrase       = options[:use_as_phrase]        == "true"
      @set_as_verified     = options[:set_as_verified]      == "true"
      @import_translations = options[:import_translations]  == "true"
      @set_as_translated   = options[:set_as_translated]    == "true"
    end

    def import
      @locale = Locale.where(app: @app, key: @set_locale).first_or_create!

      parse_obc(@obc)
    end


    private

    def parse_obc(obc)
      obc_hash = {}

      @obc.split("\n").each do |line|
        if COMMENT.match line
          next
        elsif KEY_VALUE.match line
          @current_key            = $1
          obc_hash[@current_key]  = $2
        elsif TEXT.match line
          obc_hash[@current_key] = "#{obc_hash[@current_key]}\n#{$1}"
        end
      end

      import_pairs(obc_hash)
    end

    def import_pairs(hash)
      hash.each do |key, value|
        phrase = save_phrase(key, value)
        if phrase && @import_translations
          save_translation(phrase, value)
        end
      end
    end

    def save_phrase(key, value)
      phrase = Phrase.where(app: @app, key: key).first_or_initialize

      if phrase.new_record? || @use_as_phrase
        phrase.key_is_valid = true    # skip validation to save key with dots
        phrase.value        = value
        phrase.done         = @set_as_verified
        phrase.save!

        phrase
      else
        phrase
      end
    end

    def save_translation(phrase, value)
      translation = phrase.translations.reload.where(locale: @locale).first
      translation.update_attributes!(value: value, done: @set_as_translated)
    end

  end
end
