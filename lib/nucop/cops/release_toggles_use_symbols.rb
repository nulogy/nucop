module Nucop
  # This cop checks that a symbol is used when using a Release Toggle name
  #
  # @example
  #
  #   # bad
  #
  #   release_toggle_enabled?("move_out_of_wip_autocomplete")
  #   release_toggle_enabled_for_any_site?("versioned_production_specification_ui")
  #   ReleaseToggles.enabled?("test_toggle", site_id: current_user.site_id)
  #   ReleaseToggles.disabled?("test_toggl"e, site_id: current_user.site_id)
  #   ReleaseToggles.enable("test_toggle", site_id: current_user.site_id)
  #   ReleaseToggles.disable!("test_toggle", site_id: current_user.site_id)
  #
  #   # good
  #
  #   release_toggle_enabled?(:move_out_of_wip_autocomplete)
  #
  class ReleaseTogglesUseSymbols < ::RuboCop::Cop::Cop
    MSG = "Use a symbol when refering to a Release Toggle's by name".freeze

    def_node_matcher :test_helper?, <<~PATTERN
      (send nil? {:release_toggle_enabled? :release_toggle_enabled_for_any_site?} (str _))
    PATTERN

    def_node_matcher :release_toggles_public_api_method?, <<~PATTERN
      (send (const nil? :ReleaseToggles) {:enabled? :disabled? :enable :disable :enable! :disable!} (str _) ...)
    PATTERN

    def on_send(node)
      test_helper?(node) { add_offense(node, message: MSG, location: node.children[2].loc.expression) }
      release_toggles_public_api_method?(node) { add_offense(node, message: MSG, location: node.children[2].loc.expression) }
    end

    def autocorrect(node)
      ->(corrector) do
        toggle_name = node.children[2].value

        corrector.replace(node.children[2].source_range, ":#{toggle_name}")
      end
    end
  end
end
