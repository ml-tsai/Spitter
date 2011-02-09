require 'spec_helper'

describe SessionsController do
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end 

    it "should have title" do
      get 'new'
      response.should have_selector('title', :content => "Login")
    end    
  end

  describe "Post 'Create'" do

    describe "invalid login" do

      before(:each) do
        @user = {:email => "", :password => ""}
      end

      it "should re-render login page" do
        post :create, :session => @user
        response.should render_template(:new)
      end

      it "should have title" do
        post :create, :session => @user
        response.should have_selector('title', :content => "Login")
      end

      it "should have flash error msg" do
        post :create, :session => @user
        flash.now[:error].should =~ /invalid/i
      end
      
    end

    describe "Successfull Login" do

      before(:each) do
        @user = Factory(:user)
        @attr = { :email => @user.email, :password => @user.password }
      end

      it "should sign the user in" do
        post :create, :session => @attr
        controller.current_user.should == @user
        controller.should be_signed_in 
      end

      it "should redirect to users page" do
        post :create, :session => @attr
        response.should redirect_to(user_path(@user))
      end
      
    end

  end

  describe "DELETE 'Destroy'" do

    it "should destroy session and sign out" do
      test_sign_in(Factory(:user))
      delete :destroy
      controller.should_not be_signed_in
      response.should redirect_to(root_path)
    end
    
  end

end
