class Phrase < ActiveRecord::Base
  belongs_to  :app
  has_many    :translations,  dependent: :destroy

  attr_accessor :key_is_valid

  before_validation   :encode_key,     on: :create
  validates :app_id,  presence: true
  validates :key,     presence: true,  uniqueness: { scope: :app }

  after_create :create_translations
  after_update :update_translations

  scope :default_order,       -> { order(key: :asc) }

  def untranslated
    translations.joins(:locale).where(done: false)
  end

  def untranslated_count
    untranslated.count
  end

  def translations_ordered_by_locale
    translations.joins(:locale).order('locales.key asc')
  end

  def create_translations
    app.locales.each do |locale|
      Translation.create!(app_id: app.id, locale_id: locale.id, phrase_id: self.id)
    end
  end

  def update_translations
    app.locales.each do |locale|
      t = Translation.where(app_id: app.id, locale_id: locale.id, phrase_id: self.id).first
      t.update_attributes!(done: false) if t.done
    end
  end

  def to_json(options = {})
    { app: app.key, key: key, value: value, hint: hint }.to_json
  end

  def encode_key
    if @key_is_valid
      self.key
    else
      self.key = self.key.to_s.parameterize.underscore.to_sym
    end
  end
end
