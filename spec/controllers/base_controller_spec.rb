require 'spec_helper'

describe BaseController do
  # render_views

  before :all do
    @app = App.create!(key: :my, name: "My app")

    # @locale_xy  = Locale.create!(app: @app, key: 'xy', name: 'Xylantric')
    # @phrase_abc = Phrase.create!(app: @app, locale: @locale_xy, key: :abc, value: 'ABC')
    # @phrase_def = Phrase.create!(app: @app, locale: @locale_xy, key: :def, value: 'DEF')
    # @phrase_ghi = Phrase.create!(app: @app, locale: @locale_xy, key: :ghi, value: 'GHI')

    # @locale_yz  = Locale.create!(app: @app, key: 'yz', name: 'Yzzy')
    # @phrase_mno = Phrase.create!(app: @app, locale: @locale_yz, key: :mno, value: 'MNO')
    # @phrase_poq = Phrase.create!(app: @app, locale: @locale_yz, key: :poq, value: 'POQ')
    # @phrase_rst = Phrase.create!(app: @app, locale: @locale_yz, key: :rst, value: 'RST')
  end

  after :all do
    Translation.destroy_all
    Phrase.destroy_all
    Locale.destroy_all
    App.destroy_all
  end

  context "actions" do
    describe "#index" do
      let(:base) { BaseController.new }

      before :each do
        # base.stub(:controller_name).and_return "translations"
        # controller.instance_variable_set(:@model_name, "translation")
        # controller.instance_variable_set(:@klass, Translation)
        # controller.instance_variable_set(:@app, @app)
        # controller.instance_variable_set(:@filter, {})
        # controller.instance_variable_set(:@sort, {})
      end

      it "calls scope"
      it "calls filter"
      it "calls sort"
      it "calls join"
      it "calls paginate"
      it "responds with the correct instance"
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
    end
  end

  context "before_filters" do
    it "calls set_model_name_and_klass"
    it "calls ensure_app"

    context "#index" do
      it "calls ensure_filter"
      it "calls ensure_sort"
    end
  end

  context "private helper methods" do
    describe "set_model_name_and_klass" do
    end
    describe "capitalize_" do
    end
    describe "respond" do
    end
    describe "ensure_app" do
    end

    context "for index" do
      describe "ensure_filter" do
      end
      describe "ensure_sort" do
      end
      describe "ensure_join" do
      end
      describe "scope" do
      end
      describe "filter" do
      end
      describe "sort" do
      end
      describe "join" do
      end
      describe "paginate" do
      end
    end
  end
end

