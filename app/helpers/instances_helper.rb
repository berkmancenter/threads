module InstancesHelper
  def can_see_settings?(instance)
    can?(:toggle_open_topic, instance) ||
      can?(:update, instance) ||
      can?(:set_moderators, instance)
  end
end
