class CreateAllTheModels < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.string      :name
      t.string      :key
      t.timestamps
    end
    add_index :apps, :key, :unique => true

    create_table :locales do |t|
      t.integer     :app_id
      t.string      :name
      t.string      :key
      t.boolean     :hidden,      :default => false
      t.timestamps
    end
    add_index :locales, :key
    add_index :locales, :hidden

    create_table :phrases do |t|
      t.integer     :app_id
      t.string      :key
      t.text        :value
      t.text        :hint
      t.boolean     :done,        :default => false
      t.boolean     :hidden,      :default => false
      t.timestamps
    end
    add_index :phrases, :key
    add_index :phrases, :done
    add_index :phrases, :hidden

    create_table :translations do |t|
      t.integer     :app_id
      t.integer     :locale_id
      t.integer     :phrase_id
      t.text        :value
      t.boolean     :done,        :default => false
      t.boolean     :hidden,      :default => false
      t.timestamps
    end
    add_index :translations, :done
    add_index :translations, :hidden
  end
end
