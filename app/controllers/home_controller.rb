class HomeController < ApplicationController

  def index
  end
  
  def faq
    @menu << :faq
  end
  
  def agb
    @menu << :agb
  end
  
  def contact
    @menu << :contact
  end
  
  protected
  def init_menu
    @menu = [:home]
  end
end
