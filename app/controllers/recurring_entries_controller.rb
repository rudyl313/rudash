class RecurringEntriesController < ApplicationController
  before_filter :only_view_own_entries

  def index
    @user = User.find(params[:user_id])
  end

  private
  def only_view_own_entries
    unless (params[:user_id] == current_user.id.to_s)
      redirect_to(user_entries_path(current_user))
    end
  end
end
