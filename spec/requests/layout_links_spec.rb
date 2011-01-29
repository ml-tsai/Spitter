require 'spec_helper'

describe "LayoutLinks" do

  it "should have about page at /" do
    get '/about'
    response.should have_selector('title' , :content => "About")
  end
  
end

