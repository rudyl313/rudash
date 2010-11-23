class EntriesController < ApplicationController
  before_filter :only_view_own_entries
  before_filter :handle_order_time, :only => [:create]

  respond_to :html, :json
  layout "empty", :only => [:show]
  layout "application", :except => [:show]

  def index
    @dates = ((Date.today)..(Date.today + 10.days)).to_a
  end

  def new
  end

  def show
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
    redirect_to(user_entries_path(current_user)) unless (params[:user_id] == current_user.id.to_s)
  end

  def handle_order_time
    if params[:entry][:due_time].blank?
      params[:entry][:order_time] = Entry.generate_order_time
    else
      params[:entry][:order_time] = params[:entry][:due_time]
    end
  end
end
