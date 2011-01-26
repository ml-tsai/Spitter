class PagesController < ApplicationController
  
  def home
  	  @pagetitle = "Home"
  end
  
  
  def contact
  	  @pagetitle = "Contact"
  end

  def about
  	   @pagetitle = "About Us"
  end
  
end
