class UsersController < ApplicationController

  def index
    @pagetitle = "All Users"
    @user = User.all
  end

  def show
    @pagetitle = "Current User"
    @user = User.find(params[:id])
  end

  def new
   @pagetitle = "Sign Up"
  end

end
