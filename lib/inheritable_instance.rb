require "inheritable_instance/version"
require "inheritable_instance/safe_deep_dup"
require "inheritable_instance/includible"
require "set"

module InheritableInstance

  def inheritable_instance(ivar, value)
    ivar = ivar.to_sym
    inheritable_instance_vars << ivar
    instance_variable_set ivar, value
  end

  def inherited(subclass)
    super
    inheritable_instance_vars.each do |ivar|
      original  = instance_variable_get(ivar)
      duplicate = SafeDeepDup.duplicate(original)
      subclass.instance_variable_set(ivar, duplicate)
    end
  end

  private

  def inheritable_instance_vars
    @inheritable_instance_vars ||= Set.new([:@inheritable_instance_vars])
  end

end
