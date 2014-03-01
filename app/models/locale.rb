class Locale < ActiveRecord::Base
  belongs_to  :app
  has_many    :translations
  has_many    :phrases,       through: :translations

  before_validation(on: :create) { self.key = self.key.to_s.parameterize.underscore.to_sym }
  validates :app_id, presence: true
  validates :key,    presence: true,  uniqueness: { scope: :app }

  after_create :create_translations

  scope :default_order,       -> { order(name: :asc) }
  scope :untranslated,        -> { joins(:translations).where("translations.done = FALSE") }
  scope :untranslated_count,  -> { untranslated.count }

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

end
