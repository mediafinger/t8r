class Phrase < ActiveRecord::Base
  belongs_to  :app
  has_many    :translations,  dependent: :destroy

  before_validation(on: :create) { self.key = self.key.to_s.parameterize.underscore.to_sym }
  validates :app_id, presence: true
  validates :key,    presence: true,  uniqueness: { scope: :app }

  after_create :create_translations
  after_update :update_translations

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
end
