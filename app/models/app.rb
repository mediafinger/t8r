class App < ActiveRecord::Base
  has_many :locales,      dependent: :destroy
  has_many :phrases,      dependent: :destroy
  has_many :translations, dependent: :destroy

  before_validation(on: :create) { self.key = self.key.to_s.parameterize.underscore.to_sym }
  validates :key,    presence: true,  uniqueness: true
end
