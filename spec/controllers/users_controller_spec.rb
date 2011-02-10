require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'index'" do

    describe "for non-signed in users" do

      it "should reject guest users" do
        get 'index'
        response.should redirect_to(login_path)
        flash[:notice].should =~ /Please login/
      end
      
    end

    describe "for logged in user" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
        second = Factory(:user, :email => "jeff@gcds.com.au")
        third = Factory(:user, :email => "hasan@gcds.com.au")

        @users = [@user, second, third]
        30.times do
          @users << Factory(:user, :email => Factory.next(:email))
        end
      end

      it "should get index" do
        get 'index'
        response.should be_success
      end

      it "should have right title" do
        get 'index'
        response.should have_selector('title', :content => 'All Users')
      end

      it "should have a link for each user" do
        get 'index'
        @users[0..2].each do |user|
          response.should have_selector('li', :content => user.name)
        end
      end

      it "should paginate users" do
        get 'index'
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/users?page=2",
          :content => "2")
        response.should have_selector("a", :href => "/users?page=2",
          :content => "Next")

      end


      

      
    end
    
  end

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

  describe "GET 'edit'" do

    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector('title', :content => "Edit")
    end

    it "should have update form" do
      get :edit, :id => @user
      gravatar_url = "http://gravatar.com/emails"
      response.should have_selector('a', :href => gravatar_url, :content => "Edit")
    end

  end

  describe "PUT 'update'" do
    
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    describe "Failure" do

      before(:each) do
        @attr = {:name => "", :email => "", :password => "", :password_confirmation => ""}
      end

      it "should render edit page" do
        put :update, :id => @user, :user => @attr
        response.should render_template('edit')
      end

      it "should have right title" do
        put :update, :id => @user, :user => @attr
        response.should have_selector('title', :content => "Edit")
      end

    end

    describe "Success" do

      before(:each) do
        @attr = {:name => "New Name", :email => "newemail@gcds.com.au",
          :password => "password", :password_confirmation => "password"}
      end

      it "should change the user details" do
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.email == @attr[:email]
        @user.name == @attr[:name]
      end

      it "should redirect to user profile" do
        put :update, :id => @user, :user => @attr
        response.should redirect_to(user_path(@user))
      end

      it "should have a flash message" do
        put :update, :id => @user, :user => @attr
        flash[:success].should =~ /updated/
      end


    end

  end

  describe "DELETE 'destroy" do

    before(:each) do
      @user = Factory(:user)
    end

    describe "as guest user" do
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(login_path)
      end
    end

    describe "logged in as standard user" do
      it "should protect the page" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to(root_path)
      end
    end

    describe "logged in as admin" do

      before(:each) do
        @admin = Factory(:user, :email => "zarned@gcds.com.au", :admin => true)
        test_sign_in(@admin)
      end

      it "should destroy the user" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end

      it "should redirect to users page" do
        delete :destroy, :id => @user
        response.should redirect_to(users_path)
      end

    end

  end

  describe "Authenticate edit page" do

    before(:each) do
      @user = Factory(:user)
    end

    describe "for non signed in users" do

      it "deny access to edit" do
        get :edit, :id => @user
        response.should redirect_to(login_path)
      end

      it "deny access to update" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(login_path)
      end
      
    end

    describe "for signed in user" do

      before(:each) do
        wrong_user = Factory(:user, :email => "example@gcds.com.au")
        test_sign_in(wrong_user)
      end

      it "should require matching users for 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end

      it "should require matching users for 'edit'" do
        get :edit, :id => @user, :user => {}
        response.should redirect_to(root_path)
      end

    end
    
  end
  
end