class PagesController < ApplicationController
  def index
    render html: File.read(Rails.root.join("public", "index.html"))
  end
end
