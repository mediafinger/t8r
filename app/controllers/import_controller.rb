class ImportController < ApplicationController
  before_filter :ensure_app
  respond_to    :html, :json

  def show
  end

  def upload_yaml
    @app  = App.find(upload_params[:app_id])
    @yaml = YAML::load(upload_params[:file].read)

    parse_yaml(@app, @yaml)

    render :show, status: :ok
  end

  def parse_yaml(app, yaml)
    key = yaml.first.first
    Locale.where(app: app, key: key).first_or_create!

    parse_yaml_tree(app, "", yaml.first.last)
  end

  def parse_yaml_tree(app, parent, tree)
    tree.each do |key, value|
      if value.is_a? Hash
        parse_yaml_tree(app, parent_key(parent, key), value)
      elsif value.is_a? Array
        phrase = Phrase.new(app: app, key: parent_key(parent, key), value: value.inspect) # TODO ?
        phrase.key_is_valid = true   # skip validation to save key with dots
        phrase.save
      elsif value.is_a? String
        phrase = Phrase.new(app: app, key: parent_key(parent, key), value: value)
        phrase.key_is_valid = true   # skip validation to save key with dots
        phrase.save
      end
    end
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

    params
  end
end
