class StatsLogin < ActiveRecord::Base

  def self.log login, type
    StatsLogin.create! :login => login, :login_at => Time.now, :login_type => type
  end
end
