class UsersController < ApplicationController

  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => :destroy


  def index
    @pagetitle = "All Users"
    @users = User.paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @user = User.find(params[:id])
    @pagetitle = @user[:name]
  end

  def new
      @user = User.new
      @pagetitle = "Sign Up"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome"
      redirect_to @user
    else
      @pagetitle = "Sign Up"
      @user.password = ""
      @user.password_confirmation = ""
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    @pagetitle = "Edit your profile"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Your profile has been updated successfully"
      redirect_to @user
    else
      @pagetitle = "Edit your profile"
      render 'edit' 
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User has been deleted"
    redirect_to users_path
  end

  private

  def authenticate
    deny_access unless signed_in?
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path, :notice => "You cant edit other users profiles egg" unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

end
