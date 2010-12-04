class Admin::MainController < Admin::AbstractAdminController

  def index
  end

  protected
  def init_menu
    @menu = [:admin]
  end

end
