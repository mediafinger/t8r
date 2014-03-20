class Phrase < ActiveRecord::Base
  belongs_to  :app
  has_many    :translations,  dependent: :destroy

  attr_accessor :key_is_valid

  before_validation   :encode_key,     on: :create
  validates :app_id,  presence: true
  validates :key,     presence: true,  uniqueness: { scope: :app }

  after_create :create_translations
  after_update :invalidate_translations
  after_update :hide_translations

  scope :active,            -> { where(hidden: false) }
  scope :archived,          -> { where(hidden: true)  }
  scope :verified,          -> { where(done: true)    }
  scope :unverified,        -> { where(done: false)   }
  scope :unverified_count,  -> { untranslated.count   }


  def untranslated
    translations.joins(:locale).where(done: false)
  end

  def untranslated_count
    untranslated.count
  end

  def translations_ordered_by_locale
    translations.joins(:locale).order('locales.key asc')
  end

  def copy_translations_from(phrase)
    self.translations.each do |translation|
      translation.update_attributes(value: phrase.translations.where(locale: translation.locale).first.value)
    end
  end

  def create_translations
    app.locales.each do |locale|
      Translation.create!(app_id: app.id, locale_id: locale.id, phrase_id: self.id)
    end
  end

  def invalidate_translations
    return unless self.done_changed? || self.value_changed?
    return unless self.done

    Translation.by_phrase(self).translated.each do |translation|
      translation.update_attributes!(done: false)
    end
  end

  def hide_translations
    return unless self.hidden_changed?

    if self.hidden?
      self.translations.active.each do |translation|
        translation.update_attributes!(hidden: true)
      end
    else
      self.translations.each do |translation|
        translation.update_attributes!(hidden: false)
      end
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
