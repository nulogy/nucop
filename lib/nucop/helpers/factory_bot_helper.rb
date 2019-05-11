module Nucop
  module Helpers
    module FactoryBotHelper
      extend self

      FACTORY_BOT_METHODS = [
        :build,
        :build_list,
        :build_pair,

        :create,
        :create_list,
        :create_pair,

        :build_stubbed,
        :build_stubbed_list,
        :build_stubbed_pair,

        :attributes_for,
        :attributes_for_list,
        :attributes_for_pair
      ]
      private_constant :FACTORY_BOT_METHODS

      def factory_bot_methods_pattern
        FACTORY_BOT_METHODS.map(&:inspect).join(" ")
      end
    end
  end
end
