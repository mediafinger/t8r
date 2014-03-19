class Locale < ActiveRecord::Base
  belongs_to  :app
  has_many    :translations
  has_many    :phrases,       through: :translations

  before_validation { self.key = self.key.to_s.parameterize.underscore.to_sym }
  validates :app,   presence: true
  validates :key,   presence: true,  uniqueness: { scope: :app }

  before_create :set_name
  after_create  :create_translations

  def untranslated
    translations.joins(:phrase).where(done: false)
  end

  def untranslated_count
    untranslated.count
  end

  def translations_ordered_by_phrase
    translations.joins(:phrase).order('phrase.key asc')
  end

  def create_translations
    app.phrases.each do |phrase|
      Translation.create!(app_id: app.id, locale_id: self.id, phrase_id: phrase.id)
    end
  end

  def to_json(options = {})
    { app: app.key, name: name, key: key }.to_json
  end


  private

  def set_name
    self.name = self.key  unless self.name.present?
  end
end
