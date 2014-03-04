class App < ActiveRecord::Base
  has_many :locales,      dependent: :destroy
  has_many :phrases,      dependent: :destroy
  has_many :translations, dependent: :destroy

  before_validation  { self.key = self.key.to_s.parameterize.underscore.to_sym }
  validates :key,    presence: true,  uniqueness: true

  scope :default_order,  -> { order(name: :asc) }

  def to_json(options = {})
    { name: name, key: key }.to_json
  end
end
