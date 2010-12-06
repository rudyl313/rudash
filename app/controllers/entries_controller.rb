class EntriesController < ApplicationController
  DAYS_INCREMENT = 14

  before_filter :only_view_own_entries
  before_filter :handle_order_time, :only => [:create]
  before_filter :insert_in_right_position, :only => [:update]
  before_filter :replace_completed_at, :only => [:update]

  respond_to :html, :json
  layout "empty", :only => [:show]
  layout "application", :except => [:show]

  def index
    @user = User.find(params[:user_id])
    old_entry = @user.entries.where("completed_at IS NULL").order(:due_date).first
    start_date = old_entry ? [Date.today,old_entry.due_date].min : Date.today
    @user.entries.where("due_date < ?",start_date).destroy_all
    num_days = params[:num_days] ? params[:num_days].to_i : DAYS_INCREMENT
    @dates = ((start_date)..(start_date + num_days.days)).to_a
    RecurringEntry.generate_entries(@dates,@user)
    @more_days = num_days + DAYS_INCREMENT
  end

  def new
  end

  def show
    @user = User.find(params[:user_id])
    @entry = Entry.find(params[:id])
  end

  def create
    user = User.find(params[:user_id])
    @entry = user.entries.build(params[:entry])
    @entry.save
    respond_with(user,@entry)
  end

  def edit
  end

  def update
    user = User.find(params[:user_id])
    @entry = Entry.find(params[:id])
    @entry.update_attributes(params[:entry])
    respond_with(user,@entry)
  end

  private
  def only_view_own_entries
    unless (params[:user_id] == current_user.id.to_s)
      redirect_to(user_entries_path(current_user))
    end
  end

  def handle_order_time
    if params[:entry][:due_time].blank?
      params[:entry][:order_time] = Entry.generate_order_time
    else
      params[:entry][:order_time] = params[:entry][:due_time]
    end
  end

  def insert_in_right_position
    if params[:after]
      params[:entry][:order_time] =
        Entry.order_time_to_be_after(params[:after],params[:id],
                                     params[:entry][:due_date])
    end
  end

  def replace_completed_at
    if params[:entry][:completed_at] == "now"
      params[:entry][:completed_at] = Time.now
    end
  end
end
