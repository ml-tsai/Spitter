class PagesController < ApplicationController
  def home
  	  @pagetitle = "Home-Page"
  end
  
  
  def contact
  	  @pagetitle = "Contact"
  end
  
  def services
  	  @pagetitle = "Services"
  	  
  end

  def about
  	   @pagetitle = "About Us"
  end

  
end
