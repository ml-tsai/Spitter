require 'spec_helper'

describe UsersController do
  render_views

  
  
  describe "GET 'new'" do
    
    it "should be successful" do
      get 'new'
      response.should be_success
    end

    it "called New User" do
      get 'new'
      response.should have_selector('title', :content => "Sign Up")
    end

    describe "Post create" do

      describe "should be success" do

        before(:each) do
          @user = {:name => "James", :email => "jasmes@gcds.com.au", :password => "independent", :password_confirmation => "independent"}
        end

        it "should create user" do
          lambda do
            post :create, :user => @user 
          end.should change(User, :count).by(1)
        end

        it "should redirect to users page" do
          post :create, :user => @user 
          response.should redirect_to(user_path(assigns(:user))) #Make sure user doesnt already exist otherwise will throw error

        end
 
        it "should flash success" do
          post :create, :user => @user
          flash[:success].should =~ /Welcome/i
        end

        it "should sign the user in" do
          post :create, :user => @user
          controller.should be_signed_in
        end

      end

      describe "failed to sign up" do

        before(:each) do
          @user = {:name => "", :email => "", :password => "", :password_confirmation => ""}
        end

        it "should not create user" do
          lambda do
            post :create, :user => @user
          end.should_not change(User, :count)
        end

        it "should have title" do
          post :create, :user => @user
          response.should have_selector('title', :content => "Sign Up")
        end

        it "should render 'new' page" do
          post :create, :user => @user
          response.should render_template(:new)
        end

      end
    end

  end

 
  describe "GET 'show'" do

    before(:each) do
      @user = Factory(:user)
    end

    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end

    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end

    it "should have a page title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end

    it "should have a heading" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.name)
    end

    it "should have a image" do
      get :show, :id => @user
      response.should have_selector("img", :class => "gravatar")
    end
    
  end

end
