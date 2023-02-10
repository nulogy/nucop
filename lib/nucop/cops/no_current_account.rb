module Nucop
  # This cop looks for usages of current_account
  #
  # @example
  #
  #   # bad
  #   if current_account.using_standard_packaging_uoms?
  #     <do something>
  #   end
  #
  #   # good
  #
  #   if Current.account.using_standard_packaging_uoms?
  #     <do something>
  #   end
  #
  class NoCurrentAccount < ::RuboCop::Cop::Cop
    MSG = "current_account is soft deprecated. Use Current.account instead.".freeze

    def_node_matcher :on_current_account, <<~PATTERN
      (send ... :current_account)
    PATTERN

    def on_send(node)
      on_current_account(node) do
        add_offense(node, message: MSG)
      end
    end
  end
end
