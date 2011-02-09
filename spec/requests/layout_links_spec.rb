require 'spec_helper'

describe "LayoutLinks" do

  describe "when signed out" do
    it "should have a sign up link" do
      visit root_path
      response.should have_selector('a', :href => signup_path, :content => "Sign Up")
    end
    it "should have a login link" do
      visit root_path
      response.should have_selector('a', :href => login_path,  :content => "Login")
    end
  end

  describe "when signed in" do

    before(:each) do
      @user = Factory(:user)
      visit login_path
      fill_in :email, :with => @user.email
      fill_in :password, :with => @user.password
      click_button
    end

    it "should have logout link" do
      visit root_path
      response.should have_selector('a', :href => logout_path, :content => "Logout")
    end

    it "should have member nav" do
      visit root_path
      response.should have_selector('ul', :id => "member_nav")
      response.should have_selector('a', :href => user_path(@user), :content => "Profile")
    end
    
  end


  it "should have the main Navigation links" do
    visit root_path
    click_link "About"
    response.should have_selector("title", :content => "About Us")
    click_link "Help"
    response.should have_selector("title", :content => "Help") 
    click_link "Sign Up"
    response.should have_selector("title", :content => "Sign Up")
    click_link "Contact"
    response.should have_selector("title", :content => "Contact")
    click_link "Home"
    response.should have_selector("title", :content => "Home")
  end
  
end