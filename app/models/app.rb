class App < ActiveRecord::Base
  has_many :locales,      dependent: :destroy
  has_many :phrases,      dependent: :destroy
  has_many :translations, dependent: :destroy
end
