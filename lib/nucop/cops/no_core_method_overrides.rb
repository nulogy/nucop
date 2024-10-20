module Nucop
  # This cop looks for core method overrides
  #
  # @example
  #
  #   # bad
  #
  #   def blank?
  #     # ...
  #   end
  #
  #   # good
  #
  #   def anything_other_than_blank?
  #     # ...
  #   end
  #
  class NoCoreMethodOverrides < ::RuboCop::Cop::Base
    MSG = "Core method overridden".freeze

    def_node_matcher :core_methods, <<~PATTERN
      (def ${:present? :blank? :empty?} ...)
    PATTERN

    def on_def(node)
      core_methods(node) do |method|
        add_offense(node, message: format(MSG, method: method))
      end
    end
  end
end
