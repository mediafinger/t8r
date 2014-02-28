class Phrase < ActiveRecord::Base
  belongs_to  :app
  has_many    :translations,  dependent: :destroy

  validates :app_id, presence: true
  validates :key,    presence: true,  uniqueness: { scope: :app }
end
