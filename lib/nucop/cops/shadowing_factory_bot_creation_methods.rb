module Nucop
  # This cop looks for defined methods in spec files that would shadow methods defined in FactoryBot::Syntax::Methods.
  # See FactoryBotHelper::FACTORY_BOT_METHODS constant for a complete list.
  #
  # @example
  #
  #   # bad
  #
  #   def create(args)
  #     ...
  #   end
  #
  #   # good
  #
  #   def create_transfer_pallet(args)
  #     ...
  #   end
  class ShadowingFactoryBotCreationMethods < ::RuboCop::Cop::Cop
    include Helpers::FilePathHelper

    MSG = "Method `%<method>s` shadows a FactoryBot method. Please rename it to be more specific."

    def_node_matcher :factory_bot_methods, <<~PATTERN
      (def ${#{Helpers::FactoryBotHelper.factory_bot_methods_pattern}} ...)
    PATTERN

    def on_def(node)
      factory_bot_methods(node) do |method|
        add_offense(node, location: :expression, message: format(MSG, method: method))
      end
    end

    def relevant_file?(file)
      acceptance_or_spec_file?(file) && super
    end
  end
end
