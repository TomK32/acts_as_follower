module FollowerLib
  
  private
  
  # Retrieves the parent class name if using STI.
  def parent_class_name(obj)
    if obj.class.superclass != ActiveRecord::Base
      return obj.class.superclass.name
    end
    return obj.class.name
  end
  
  def follower_and_followable_conditions(follower, followable)
    {:follower_id => follower.id, :follower_type => parent_class_name(follower),
    :followable_id => followable.id, :followable_type => parent_class_name(followable)}
  end
  
end
