class HomeController < ApplicationController

  def index
    @list = List.new
    @lists = List.all
  end

end
