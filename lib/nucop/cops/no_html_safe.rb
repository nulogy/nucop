module Nucop
  # This cop looks for usages of html_safe.
  #
  # @example
  #
  #   # bad
  #
  #   html = "<td>some stuff</td>".html_safe
  #
  #   # good
  #
  #   html = tag.td("some stuff")
  #
  class NoHtmlSafe < ::RuboCop::Cop::Cop
    MSG = "Avoid using html_safe. Consider using tag helpers instead.".freeze

    def_node_matcher :on_html_safe, <<~PATTERN
      (send ... :html_safe)
    PATTERN

    def on_send(node)
      on_html_safe(node) do
        add_offense(node, message: MSG)
      end
    end
  end
end
