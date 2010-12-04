module ActiveRecord

  module UserMonitor

    def self.included(base)

      base.class_eval do
        alias_method :create_without_user, :create
        alias_method :create, :create_with_user

        alias_method :update_without_user, :update
        alias_method :update, :update_with_user
      end
    end

    def create_with_user
        user = User.current_user
        if user.kind_of? User
          self[:created_by] = user.login if respond_to?(:created_by)
          self[:updated_by] = user.login if respond_to?(:updated_by)
        else
          self[:created_by] = 'system' if respond_to?(:created_by)
          self[:updated_by] = 'system' if respond_to?(:updated_by)
        end
        create_without_user
    end

    def update_with_user
        user = User.current_user
        if user
          self[:updated_by] = user.login if respond_to?(:updated_by)
        else
          self[:updated_by] = 'system' if respond_to?(:updated_by)
        end
        update_without_user
    end

#    def created_by
#      begin
#        user_model.find(self[:created_by])
#      rescue ActiveRecord::RecordNotFound
#        nil
#      end
#    end
#
#    def updated_by
#      begin
#        user_model.find(self[:updated_by])
#      rescue ActiveRecord::RecordNotFound
#        nil
#      end
#    end
  end

#  class Base
#
#    @@default_user_model = :users
#    cattr_accessor :user_model_name
#
#    def user_model_name
#      @@user_model_name || @@default_user_model
#    end
#
#    def self.relates_to_user_in(model)
#      self.user_model_name = model
#    end
#
#    def user_model
#      Object.const_get(user_model_name.to_s.singularize.humanize)
#    end
#  end
end