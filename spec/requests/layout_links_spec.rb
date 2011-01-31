require 'spec_helper'

describe "LayoutLinks" do


  it "should have the right links on teh layout" do
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

