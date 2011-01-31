module ApplicationHelper


  def title
   base_title = "Spitter"
    if @pagetitle.nil?
      base_title
    else
        "#{base_title} | #{@pagetitle}"
    end
  end
  
end
