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
   @pagetitle = "Sign Up"
  end

end
