module Nucop
  module Helpers
    # Knows the list of gems the nucop makes available.
    module RubocopGemDependencies
      module_function

      def rubocop_gems
        %w[
          rubocop
          rubocop-capybara
          rubocop-factory_bot
          rubocop-graphql
          rubocop-performance
          rubocop-rails
          rubocop-rake
          rubocop-rspec
          rubocop-rspec_rails
          rubocop-rubycw
          rubocop-thread_safety
        ]
      end
    end
  end
end
