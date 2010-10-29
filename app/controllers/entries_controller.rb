class EntriesController < ApplicationController
  before_filter :only_view_own_entries

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

  private
  def only_view_own_entries
    redirect_to(user_entries_path(current_user)) unless (params[:user_id] == current_user.id.to_s)
  end
end
