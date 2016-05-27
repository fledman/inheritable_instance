module InheritableInstance
  module Includible

    def self.included(base)
      base.extend InheritableInstance
    end

  end
end
