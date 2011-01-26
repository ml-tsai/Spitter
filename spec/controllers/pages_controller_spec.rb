require 'spec_helper'

describe PagesController do

  describe "GET 'home'" do
    
    render_views
    
    # Home exists
    it "should be successful" do
      get 'home'
      response.should be_success
    end
    
    #TItle Exists
     it "should have the correct title" do
      get 'home'
      response.should have_selector( "title")
 
    end
    
  end

  describe "GET 'contact'" do   
    it "should be successful" do
      get 'contact'
      response.should be_success
    end
  end

   describe "Get 'about'" do
     it "should be successful" do
       get 'about'
       response.should be_success
     end
 end
 
 

end
