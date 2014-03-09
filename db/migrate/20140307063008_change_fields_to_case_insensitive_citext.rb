class ChangeFieldsToCaseInsensitiveCitext < ActiveRecord::Migration

  if ActiveRecord::Base.connection.instance_values["config"][:adapter] == "postgresql"

  # To enable a general case insensitve sorting on the fields in Postgres
  # First activate extension citext:

  # psql

  # \c database_name
  # CREATE EXTENSION citext;
  # \q

  # then run migration
  # http://www.sfcgeorge.co.uk/posts/2013/11/12/case-insensitive-usernames-with-postgres

  # In case Travis-CI is used, add to travis.yml:

  # before_script:
  # - psql -c 'create database t8r_test;' -U postgres
  # - psql -c 'create extension citext;' -U postgres -d t8r_test
  # - "bundle exec rake db:migrate"
  # - "bundle exec rake db:test:prepare"


    def up
      change_table :apps, :bulk => true do |t|
        t.change :name, :citext
        t.change :key,  :citext
      end

      change_table :locales, :bulk => true do |t|
        t.change :name, :citext
        t.change :key,  :citext
      end

      change_table :phrases, :bulk => true do |t|
        t.change :value, :citext
        t.change :key,   :citext
      end

      change_table :translations, :bulk => true do |t|
        t.change :value, :citext
      end
    end

    def down
      change_table :apps, :bulk => true do |t|
        t.change :name, :string
        t.change :key,  :string
      end

      change_table :locales, :bulk => true do |t|
        t.change :name, :string
        t.change :key,  :string
      end

      change_table :phrases, :bulk => true do |t|
        t.change :value, :text
        t.change :key,   :string
      end

      change_table :translations, :bulk => true do |t|
        t.change :value, :text
      end
    end

  else
    puts "ChangeFieldsToCaseInsensitiveCitext is a postgresql only migration - doing nothing."
  end
end
