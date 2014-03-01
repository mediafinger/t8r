class Translation < ActiveRecord::Base
  belongs_to  :app
  belongs_to  :locale
  belongs_to  :phrase

  validates :app_id,    presence: true
  validates :locale_id, presence: true
  validates :phrase_id, presence: true, uniqueness: { scope: :locale }

  scope :by_locale,           lambda { |locale| where(locale_id: locale.id) }
  scope :by_phrase,           lambda { |phrase| where(phrase_id: phrase.id) }
  scope :default_order,       -> { order(done: :asc, updated_at: :asc) }
  scope :untranslated,        -> { where(done: false) }
  scope :untranslated_count,  -> { untranslated.count }

  def untranslated?
    !done
  end

  def to_info
    "#{app.key}.#{locale.key}.#{phrase.key} = #{value}"
  end

  def to_json(options = {})
    { app: app.key, locale: locale.key, phrase: phrase.key, value: value, done: done }.to_json
  end

  def to_s
    value
  end

  def to_yml
    "#{locale.key.downcase}: #{app.key.upcase}_#{phrase.key.upcase}: #{value}"
  end
end
