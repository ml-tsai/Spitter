require 'spec_helper'

describe "User" do

  before(:each) do
    @example = {
      :name => "Zarne",
      :email => "zarne@gcds.com.au",
      :password => "independent",
      :password_confirmation => "independent"
    } 
  end

  it "should create a new user" do
    User.create!(@example)
  end
  
  it "should have a name" do
    @no_name = User.new(@example.merge(:name =>""))
    @no_name.should_not be_valid
  end

  it "should have email" do
    @no_email = User.new(@example.merge(:email => ""))
    @no_email.should_not be_valid
  end

  it "should have name no more than 50 chars" do
    long_name = "z" * 51
    @long_name = User.new(@example.merge(:name => long_name))
    @long_name.should_not be_valid
  end

  it "should have a unique valid email" do
    User.create!(@example)
    @new_name = User.new(@example)
    @new_name.should_not be_valid
  end

  describe "sign up" do

    before(:each) do
      @user = User.create!(@example)
    end

    it "should have a password" do
      User.create(@example.merge(:password => "", :password_confirmation => "")).should_not be_valid
    end

    it "should match password confirmation" do
      User.create(@example.merge(:password_confirmation => "differentToPassword")).should_not be_valid
    end

    it "should reject short passwords" do
      User.create(@example.merge(:password => "a"*5, :password_confirmation => "a"*3)).should_not be_valid
    end

    it "should reject long passwords" do
      User.create(@example.merge(:password => "a"*26, :password_confirmation => "a"*26)).should_not be_valid
    end

    it "should have an encrypted password" do
      @user.respond_to?(:encrypted_password)
    end
  
    it "should save as encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    describe "Encrypted Passwords. " do

      it "should be true that the password match" do
        @user.has_password?(@example[:password]).should be_true
      end

      it "should fail the test when invalid match" do 
        @user.has_password?("crazywrongpass").should be_false
      end

      describe "Authenticate User" do

        it "should return nil on password mismatch" do
          wrongpass = User.authenticate(@user[:email], "wrongpass")
          wrongpass.should be_nil  
        end

        it "should return nill on email mismatch" do
          wrong_email = User.authenticate("zarne@gcds.com", @user[:password])
          wrong_email.should be_nil
        end 

        it "should return user on authenticated success" do
          correct_user = User.authenticate(@example[:email], @example[:password])
          correct_user.should == @user
        end 

        
      end


    end


  end

  describe "sign in" do

    describe "failure" do

      it "should not sign user in" do
        visit login_path
        fill_in :email, :with => ""
        fill_in :password, :with => ""
        click_button
        response.should have_selector('div.flash.error', :content => "Invalid")
      end
      
    end

    describe "succefully" do

      it "should sign user in and out" do
        user = Factory(:user)
        visit login_path
        fill_in :email, :with => user.email
        fill_in :password, :with => user.password
        click_button
        controller.should be_signed_in
        click_link "Logout"
        controller.should_not be_signed_in
      end
      
    end
    
    
  end

  describe "admin attr" do

    before(:each) do
      @user = User.create!(@example)
    end

    it "should respond to admin" do
      @user.should respond_to(:admin)
    end

    it "not be an admin by default" do
      @user.should_not be_admin
    end

    it "should be convertable to admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end

  end
  
end
