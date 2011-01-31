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

  def help
    @pagetitle = "Help"
  end


end
