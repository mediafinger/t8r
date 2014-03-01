class Translation < ActiveRecord::Base
  belongs_to  :app
  belongs_to  :locale
  belongs_to  :phrase

  validates :app_id,    presence: true
  validates :locale_id, presence: true
  validates :phrase_id, presence: true, uniqueness: { scope: :locale }

  def app
    locale.app
  end

  def info
    "#{app.key}.#{locale.key}.#{phrase.key} = #{value}"
  end

  def to_yml
    "#{app.key.upcase}_#{phrase.key.upcase}: #{value}"
  end

  def to_s
    value
  end
end
