require 'spec_helper'

describe AppsController do
  # render_views

  let(:app) { App.create!(name: "AppName", key: "an") }

  before :each do
  end

  context "html" do
    describe "GET index" do
      it 'should respond with 200 code' do
        get :index, format: :html

        response.code.should == '200'
      end
    end

    describe "#show" do
    end

    describe "#new" do
    end

    describe "#create" do
    end

    describe "#edit" do
    end

    describe "#update" do
    end

    describe "#destroy" do
      it "is not accessible"
    end
  end

  context "json" do
    describe "#index" do
      it 'should respond with 200 code' do
        app
        get :index, format: :json

        parsed_response.first["key"].should == "an"
      end
    end
  end
end

