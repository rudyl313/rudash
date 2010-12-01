class RecurringEntriesController < ApplicationController
  before_filter :only_view_own_entries

  layout "empty", :only => [:show]
  layout "application", :except => [:show]

  respond_to :html

  def index
    @user = User.find(params[:user_id])
    @daily = @user.recurring_entries.where(:period => "daily")
    @weekly = @user.recurring_entries.where(:period => "weekly")
    @monthly = @user.recurring_entries.where(:period => "monthly")
    @yearly = @user.recurring_entries.where(:period => "yearly")
  end

  def show
    @user = User.find(params[:user_id])
    @rentry = RecurringEntry.find(params[:id])
  end

  def create
    user = User.find(params[:user_id])
    @rentry = user.recurring_entries.build(params[:recurring_entry])
    @rentry.save!
    respond_with(user,@rentry)
  end

  def destroy
    @user = User.find(params[:user_id])
    @rentry = RecurringEntry.find(params[:id])
    @rentry.destroy
    respond_with(@user,@rentry)
  end

  private
  def only_view_own_entries
    unless (params[:user_id] == current_user.id.to_s)
      redirect_to(user_entries_path(current_user))
    end
  end
end
