class SessionsController < ApplicationController
  def new
    @pagetitle = "Login"
  end

  def create
    user = User.authenticate(params[:session][:email], params[:session][:password])

    if user.nil?
      @pagetitle = "Login"
      flash.now[:error] = "Invalid login"
      render 'new'
    else
      #redirect to users page sugnin succuss
      flash[:success] = "Successfully Logged In"
      sign_in(user)
      redirect_to user
    end

  end

  def destroy
    flash[:success] = "You have been logged out"
    sign_out
    redirect_to root_path
  end


end
