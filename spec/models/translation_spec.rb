require 'spec_helper'

describe Translation do
  let(:app)         { App.create!(name: "AppName", key: "an") }
  let(:locale)      { Locale.create!(app: app, name: "English", key: "en") }
  let(:phrase)      { Phrase.create!(app: app, value: "Saturday-night-fever!", key: "snf") }
  let(:translation) { Translation.where(app: app, locale: locale, phrase: phrase).first }

  context "validations" do
    it "belongs_to an App" do
      translation.app.should == app
    end
    it "belongs_to a Locale" do
      translation.locale.should == locale
    end
    it "belongs_to a Phrase" do
      translation.phrase.should == phrase
    end

    it "validates the uniqueness of a phrase in the scope of the locale" do
      translation2 = Translation.new(app: app, locale: locale, phrase: phrase)
      translation2.valid?

      translation2.errors.messages[:phrase_id].should == ["has already been taken"]
    end
  end

  context "scopes and finders" do
    it "has a scope for all translations of a local" do
      phrase
      spanish = Locale.create!(app: app, name: "Spanish", key: "es")

      Translation.by_locale(spanish).to_a.should == spanish.translations.where(phrase: phrase).to_a
    end

    it "has a scope for all translations of a phrase" do
      locale
      phrase2 = Phrase.create!(app: app, value: "Fiesta Mexicana", key: "fm")

      Translation.by_phrase(phrase2).to_a.should == phrase2.translations.where(locale: locale).to_a
    end

    it "has a scope for all untranslated" do
      translation
      Translation.untranslated.last.should == translation

      translation.update_attributes!(value: "Saturday Night Fever", done: true)
      Translation.untranslated.to_a.should == []
    end

    it "has a method to count all untranslated" do
      translation

      Translation.untranslated_count.should == 1
    end
  end

  context "output" do
    before :each do
      translation.update_attributes!(value: "Saturday Night Fever", done: true)
    end

    it "#to_info returns a string" do
      translation.to_info.should == "#{app.key}.#{locale.key}.#{phrase.key} = #{translation.value}"
    end

    it "#to_json returns json" do
      translation.to_json.should == { app: app.key, locale: locale.key, phrase: phrase.key, value: translation.value, done: true }.to_json
    end

    it "#to_s returns the value" do
      translation.to_s.should == "Saturday Night Fever"
    end

    it "#to_yml returns yml" do
      translation.to_yml.should == "#{locale.key.downcase}: #{app.key.upcase}_#{phrase.key.upcase}: #{translation.value}"
    end
  end
end
