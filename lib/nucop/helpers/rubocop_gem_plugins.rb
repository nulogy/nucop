module Nucop
  module Helpers
    # Knows the list of gems the nucop makes available.
    module RubocopGemPlugins
      module_function

      def rubocop_gems
        %w[
          rubocop-performance
          rubocop-rails
          rubocop-rake
          rubocop-rspec
          rubocop-rubycw
        ]
      end
    end
  end
end
