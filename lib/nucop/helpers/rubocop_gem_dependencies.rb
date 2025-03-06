module Nucop
  module Helpers
    # Knows the list of gems the nucop makes available.
    module RubocopGemDependencies
      module_function

      def rubocop_plugins
        %w[
          rubocop-performance
          rubocop-rspec
          rubocop-rails
          rubocop-rake
          rubocop-thread_safety
        ]
      end

      def rubocop_gems
        %w[
          rubocop
          rubocop-capybara
          rubocop-factory_bot
          rubocop-graphql
          rubocop-rspec_rails
        ]
      end
    end
  end
end
