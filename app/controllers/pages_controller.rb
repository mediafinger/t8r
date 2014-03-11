class PagesController < ApplicationController
  def home
    @app_count = App.count
  end
end
