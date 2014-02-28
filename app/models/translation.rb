class Translation < ActiveRecord::Base
  belongs_to  :locale
  belongs_to  :phrase

  validates :locale_id, presence: true
  validates :phrase_id, presence: true

  def app
    locale.app
  end

  def info
    "#{app.key}.#{locale.key}.#{phrase.key} = #{value}"
  end
end
