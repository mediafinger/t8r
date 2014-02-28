# source 'https://rubygems.org'
source 'http://bundler-api.herokuapp.com'

ruby '2.1.1'

gem 'rake',                         '~> 10.1'
gem 'puma',                         '~> 2.7'
gem 'rails',                        '= 4.0.3'
gem 'pg',                           '~> 0.17'

gem 'bootstrap-sass',               '~> 3.1.1'
gem 'coffee-rails',                 '~> 4.0'
gem 'haml-rails',                   '~> 0.5'
gem 'sass-rails',                   '~> 4.0.0'
gem 'turbolinks',                   '~> 2.2'


# to speed Travis-CI up
group :development, :production do
  gem 'jquery-rails',                 '~> 3.1'
  gem 'execjs',                       '~> 2.0'
  gem 'libv8',                        '~> 3.16'
  gem 'therubyracer',                 '~> 0.12'
  gem 'uglifier',                     '~> 2.4'
end

group :development do
  gem 'awesome_print',              '~> 1.2'
  gem 'letter_opener',              '~> 1.2'
  gem 'pry',                        '~> 0.9'
end

group :development, :test do
  gem 'rspec-rails',                '~> 2.14'
end


# gem 'foreman',            '~> 0.50'
# gem 'omniauth',           '~> 1.1'
# gem 'omniauth-xing',      '~> 0.1'
# gem 'simple_form',        '~> 2.0'
# gem 'kaminari'

# development / test
# gem 'ffaker',                     '~> 1.15'
# gem 'factory_girl_rails',         '~> 4.2'
# gem 'spring',                     '~> 0.0.7'
# gem 'zeus'
