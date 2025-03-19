module Nucop
  module Helpers
    # Knows the list of gems the nucop makes available.
    module RubocopGemDependencies
      module_function

      def rubocop_plugins
        %w[
          rubocop-capybara
          rubocop-factory_bot
          rubocop-graphql
          rubocop-performance
          rubocop-rails
          rubocop-rake
          rubocop-rspec
          rubocop-rspec_rails
          rubocop-thread_safety
        ]
      end

      def rubocop_gems
        %w[
          rubocop
        ]
      end
    end
  end
end
