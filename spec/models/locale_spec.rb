require 'spec_helper'

describe Locale do
  let(:app)    { App.create!(name: "AppName", key: "an") }
  let(:locale) { Locale.create!(app: app, name: "English", key: "en") }

  context "validations" do
    it "belongs_to an App" do
      locale.app.should == app
    end

    it "validates the existence of the key" do
      locale.key = nil
      locale.valid?

      locale.errors[:key].should be
    end

    it "validates the uniqueness of the key" do
      locale
      locale2 = Locale.new(app: app, name: "American", key: "en")
      locale2.valid?

      locale2.errors.messages[:key].should == ["has already been taken"]
    end

    it "converts keys to remove special characters and spaces" do
      locale.key = "Äh Such $§ @ \ a wonderfull Key"
      locale.save

      locale.key.should == :ah_such_a_wonderfull_key
    end
  end

  context "on create" do
    it "creates empty translations for all existing phrases" do
      Phrase.create!(app: app, value: "text", key: "tex")
      deutsch = Locale.create!(app: app, name: "Deutsch", key: "de")

      Translation.by_locale(deutsch).count.should == 1
    end
  end

  context "scopes and finders" do
    it "has a method to query for all untranslated of a phrase" do
      phrase = Phrase.create!(app: app, value: "text", key: "tex")

      locale.untranslated.last.should == Translation.by_locale(locale).by_phrase(phrase).last
    end

    it "has a method to count all untranslated of a phrase" do
      Phrase.create!(app: app, value: "text", key: "tex")

      locale.untranslated_count.should == 1
    end

    it "has a finder to return sorted translations sorted by phrase"
  end
end
