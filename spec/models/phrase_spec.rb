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

    it "converts keys to remove special characters and spaces" do
      phrase.key = "Äh Such $§ @ \ a wonderfull Key"
      phrase.save

      phrase.key.should == :ah_such_a_wonderfull_key
    end
  end

  context "on create" do
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
  end

  context "scopes and finders" do
    it "defines a default_order" do
      Phrase.default_order.should be
    end

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
end
