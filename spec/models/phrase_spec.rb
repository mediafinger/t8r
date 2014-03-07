require 'spec_helper'

describe Phrase do
  let(:app)    { App.create!(name: "AppName", key: "an") }
  let(:phrase) { Phrase.create!(app: app, value: "A statement", key: "as") }

  context "validations" do
    it "belongs_to an App" do
      phrase.app.should == app
    end

    it "validates the existence of the key" do
      phrase.key = nil
      phrase.valid?

      phrase.errors[:key].should be
    end

    it "validates the uniqueness of the key" do
      phrase
      phrase2 = Phrase.new(app: app, value: "Another Statement", key: "as")
      phrase2.valid?

      phrase2.errors.messages[:key].should == ["has already been taken"]
    end
  end

  context "on create" do
    it "converts keys to remove special characters and spaces" do
      phrase2 = Phrase.create(key: "Äh Such $§ @ \ a wonderfull Key")

      phrase2.key.should == :ah_such_a_wonderfull_key
    end

    it "does not convert keys when @key_is_valid is set" do
      phrase3 = Phrase.new(key: "Äh Such $§ @ \ a wonderfull Key")
      phrase3.key_is_valid = true
      phrase.save

      phrase3.key.should == "Äh Such $§ @ \ a wonderfull Key"
    end

    it "creates empty translations for all existing locales" do
      Locale.create!(app: app, name: "Deutsch", key: "de")
      phrase2 = Phrase.create!(app: app, value: "Das ist deutsch", key: "german_text")

      Translation.by_phrase(phrase2).count.should == 1
    end
  end

  context "on update" do
    it "invalidates existing translations for all existing locales" do
      deutsch = Locale.create!(app: app, name: "Deutsch", key: "de")
      translation = Translation.by_phrase(phrase).by_locale(deutsch).first

      translation.update_attributes!(value: "Ist so", done: true)
      phrase.update_attributes!(value: "Something else")

      translation.reload.done.should == false
    end

    it "does not convert keys on update" do
      phrase.update_attributes(key: "Äh Such $§ @ \ a wonderfull Key")

      phrase.key.should == "Äh Such $§ @ \ a wonderfull Key"
    end
  end

  context "scopes and finders" do
    it "has a method to query for all untranslated of a local" do
      deutsch = Locale.create!(app: app, name: "Deutsch", key: "de")

      phrase.untranslated.last.should == Translation.by_phrase(phrase).by_locale(deutsch).last
    end

    it "has a method to count all untranslated of a local" do
      Locale.create!(app: app, name: "Deutsch", key: "de")

      phrase.untranslated_count.should == 1
    end

    it "has a finder to return sorted translations sorted by locale"
  end

  describe "encode_key" do
    it "can be called to encode the key" do
      phrase.key = "Äh Such $§ @ \ a wonderfull Key 2"
      phrase.key_is_valid = false
      phrase.encode_key
      phrase.save!

      phrase.key.should == :ah_such_a_wonderfull_key_2
    end
  end

  describe "to_json" do
    it "outputs great json"
  end
end
