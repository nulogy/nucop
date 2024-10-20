module Nucop
  # This cop looks for usages of `ActiveSupport::OrderedHash`
  #
  # Hashes in Ruby (since 1.9) enumerate their keys in the order they are
  # inserted:
  #
  # "Hashes enumerate their values in the order that the corresponding keys were inserted."
  # http://ruby-doc.org/core-2.1.6/Hash.html
  #
  # @example
  #
  #   # bad
  #
  #   hash = ActiveSupport::OrderedHash.new
  #
  #   # good
  #
  #   hash = {}
  class OrderedHash < ::RuboCop::Cop::Base
    extend RuboCop::Cop::AutoCorrector

    MSG = "Ruby hashes after 1.9 enumerate keys in order of insertion"

    def_node_matcher :ordered_hash_usage, <<~PATTERN
      (send (const (const nil? :ActiveSupport) :OrderedHash) :new)
    PATTERN

    def on_send(node)
      ordered_hash_usage(node) do
        add_offense(node, location: :expression, message: MSG) do |corrector|
          corrector.replace(node.source_range, "{}")
        end
      end
    end
  end
end
