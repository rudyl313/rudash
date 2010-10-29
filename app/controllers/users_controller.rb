class UsersController < ApplicationController
  before_filter :permissions_available

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(replace_empty_strings(params[:user]))
    if @user.save
      flash[:notice] = 'Successfully created user'
      redirect_to(users_path)
    else
      render :action => "new"
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = 'User profile was successfully updated.'
      redirect_to(users_path)
    else
      render :action => "edit"
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to(users_path)
  end

  private
  def permissions_available
    @permissions = User.permissions
  end
  def replace_empty_strings(params)
    params.each { |k,v| params[k] = v.blank? ? nil : v }
    params
  end

end
