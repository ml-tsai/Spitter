class UsersController < ApplicationController

  def index
    @users = User.all
    @pagetitle = "Current Members"
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

end
