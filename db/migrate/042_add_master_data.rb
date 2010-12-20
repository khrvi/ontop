class AddMasterData < ActiveRecord::Migration
  class MasterLogin < ActiveRecord::Base; end
  class Person < ActiveRecord::Base;end
  def self.up
    User.transaction do
      MasterLogin.create! :login => 'admin', :password => '4283'
      a = User.create! :login => 'admin', :email => 'viacheslav.mail@rambler.ru', :password => '4283', :password_confirmation => '4283'
      a.has_role 'admin'
      a.has_role 'datamanager'
      a.has_role 'user'

      Person.create! :actor_id => a.actor.id,
                     :first_name => 'Slava',
                     :last_name => 'Hrenov',
                     :phone => '2345234',
                     :position => 'ddd',
                     :birthday => '3/5/83',
                     :mobile => '22333444'
    end
  end

  def self.down
    MasterLogin.find_by_login('admin').destroy
    User.find_by_login('admin').destroy
    Person.find_by_last_name('Hrenov')
  end
end
