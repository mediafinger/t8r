require 'spec_helper'

describe App do
  let(:app) { App.create!(name: "AppName", key: "an") }

  context "validations" do
    it "validates the existence of the key" do
      app.key = nil
      app.valid?

      app.errors[:key].should be
    end

    it "validates the uniqueness of the key" do
      app
      app2 = App.new(name: "AppName2", key: "an")
      app2.valid?

      app2.errors.messages[:key].should == ["has already been taken"]
    end

    it "converts keys to remove special characters and spaces" do
      app.key = "Äh Such $§ @ \ a wonderfull Key"
      app.save

      app.key.should == :ah_such_a_wonderfull_key
    end
  end
end
