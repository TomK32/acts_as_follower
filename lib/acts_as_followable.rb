module ActiveRecord #:nodoc:
  module Acts #:nodoc:
    module Followable
      
      def self.included(base)
        base.extend ClassMethods
      end
      
      module ClassMethods
        def acts_as_followable
          has_many :follows, :as => :followable, :dependent => :destroy
          include ActiveRecord::Acts::Followable::InstanceMethods
        end
      end

      
      # This module contains instance methods
      module InstanceMethods
        
        # Returns the number of followers a record has.
        def followers_count
          self.follows.size
        end
        
        # Returns the following records.
        def followers
          Follow.find(:all, :include => [:follower], :conditions => ["followable_id = ? AND followable_type = ?", 
              self.id, parent_class_name(self)]).collect {|f| f.follower }
        end
        
        # Returns true if the current instance is followed by the passed record.
        def followed_by?(follower)
          follower.follows.find(:first, :conditions => ["followable_id = ? AND followable_type = ?", self.id, parent_class_name(self)]) ? true : false
        end
        
        # Retrieves the parent class name if using STI.
        def parent_class_name(obj)
          if obj.class.superclass != ActiveRecord::Base
            return obj.class.superclass.name
          end

          return obj.class.name
        end
      end
      
    end
  end
end
