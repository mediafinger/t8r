module Importer
  class YAML

    def initialize(app:, content:, options: {})
      @app                 = app
      @yaml                = content

      @import_translations = options[:import_translations] == "true"
      @set_as_verified     = options[:set_as_verified]     == "true"
      @set_as_translated   = options[:set_as_translated]   == "true"
      @use_as_phrase       = options[:use_as_phrase]       == "true"
    end

    def import
      parse_yaml(@yaml)
    end


    private

    def parse_yaml(yaml)
      key = yaml.first.first
      @locale = Locale.where(app: @app, key: key).first_or_create!

      parse_yaml_tree("", yaml.first.last)
    end

    def parse_yaml_tree(parent, tree)
      tree.each do |key, value|

        if value.is_a? Hash
          parse_yaml_tree(parent_key(parent, key), value)

        elsif value.is_a? Array          # TODO how should Arrays be treated?
          phrase = save_phrase(parent_key(parent, key), value.inspect)
          if phrase && @import_translations
            save_translation(phrase, value.inspect)
          end

        elsif value.is_a? String
          phrase = save_phrase(parent_key(parent, key), value)
          if phrase && @import_translations
            save_translation(phrase, value)
          end
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

    def parent_key(parent, key)
      if parent == ""
        key
      else
        "#{parent}.#{key}"
      end
    end

  end
end
