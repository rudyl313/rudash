class EntriesController < ApplicationController
  def index
    @dates = ((Date.today)..(Date.today + 10.days)).to_a
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

end
