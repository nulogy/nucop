module Nucop
  # This cop looks for WIP specs
  #
  # @example
  #
  #   # bad
  #
  #   it "tests some stuff", :wip do
  #     # ...
  #   end
  #
  #   # good
  #
  #   it "tests some stuff" do
  #     # ...
  #   end
  #
  class NoWipSpecs < ::RuboCop::Cop::Base
    MSG = "WIP spec found".freeze

    def_node_matcher :wip_it_specs_present?, <<~PATTERN
      (send nil? :it ... (sym :wip))
    PATTERN

    def_node_matcher :wip_describe_specs_present?, <<~PATTERN
      (send nil? :describe ... (sym :wip))
    PATTERN

    def on_send(node)
      return unless wip_it_specs_present?(node) || wip_describe_specs_present?(node)

      add_offense(node)
    end
  end
end
