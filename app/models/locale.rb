class Locale < ActiveRecord::Base
  belongs_to  :app
  has_many    :translations
  has_many    :phrases,       through: :translations

  validates :app_id, presence: true
  validates :key,    presence: true,  uniqueness: { scope: :app }
end
