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
      t.timestamps
    end
    add_index :locales, :key

    create_table :phrases do |t|
      t.integer     :app_id
      t.string      :key
      t.text        :value
      t.text        :hint
      t.timestamps
    end
    add_index :phrases, :key

    create_table :translations do |t|
      t.integer     :app_id
      t.integer     :locale_id
      t.integer     :phrase_id
      t.text        :value
      t.boolean     :done,        :default => false
      t.timestamps
    end
    add_index :translations, :done
  end
end
