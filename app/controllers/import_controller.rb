class ImportController < ApplicationController
  before_filter :ensure_app
  respond_to    :html, :json

  def show
  end

  def upload_yaml
    @app  = App.find(upload_params[:app_id])
    @yaml = YAML::load(upload_params[:file].read)

    @import_translations  = upload_params[:import_translations]
    @set_as_translated    = upload_params[:set_as_translated]

    parse_yaml(@yaml)

    render :show, status: :ok
  end

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

    if phrase.new_record?
      phrase.key_is_valid = true        # skip validation to save key with dots
      phrase.value = value
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

  private

  def ensure_app
    @app ||= App.find(params[:app_id])
  end

  def upload_params
    params.require(:app_id)
    params.require(:file)
    params.require(:import_translations)
    params.require(:set_as_translated)

    params
  end
end
