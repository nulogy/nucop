module Nucop
  # This cop looks for usages of `FactoryGirl.create`, etc.
  # See FactoryBotHelper::FACTORY_BOT_METHODS constant for a complete list.
  #
  # The factory methods listed are included everywhere, so referencing the constant should rarely be necessary.
  #
  # @example
  #
  #   # bad
  #
  #   job = FactoryGirl.create(:job, project: project)
  #   FactoryGirl.build(:project, code: "Super Project")
  #
  #   # good
  #
  #   job = create(:job, project: project)
  #   build(:project, code: "Super Project")
  class ExplicitFactoryBotUsage < ::RuboCop::Cop::Base
    extend RuboCop::Cop::AutoCorrector
    include Helpers::FilePathHelper

    MSG = "Do not explicitly use `%<constant>s` to build objects. The factory method `%<method>s` is globally available."

    def_node_matcher :explicit_factory_bot_usage, <<~PATTERN
      (send (const nil? {:FactoryGirl :FactoryBot}) {#{Helpers::FactoryBotHelper.factory_bot_methods_pattern}} ...)
    PATTERN

    def on_send(node)
      explicit_factory_bot_usage(node) do
        add_offense(node, location: :expression, message: format(MSG, constant: node.receiver.const_name, method: node.method_name)) do |corrector|
          corrector.replace(node.source_range, node.source.sub(/(?:FactoryGirl|FactoryBot)[.]/, ""))
        end
      end
    end

    def relevant_file?(file)
      acceptance_or_spec_file?(file) && super
    end
  end
end
