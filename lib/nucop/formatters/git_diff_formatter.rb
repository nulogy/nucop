module Nucop
  module Formatters
    class GitDiffFormatter < RuboCop::Formatter::ProgressFormatter
      def initialize(output, options = {})
        super

        populate_history_from_git
        @offenses_per_file = {}
      end

      def file_finished(file, offenses)
        return unless file_touched?(file)

        offenses_in_changes = offenses_from_git_history(file, offenses)
        @offenses_per_file[file] = offenses_in_changes.size

        # modify parent Formatter to print what we want
        @offenses_for_files[file] = offenses_in_changes if offenses_in_changes.any?
        report_file_as_mark(offenses_in_changes)
      end

      def finished(_inspected_files)
        @total_offense_count = @offenses_per_file.values.reduce(0, :+)
        @total_correction_count = 0

        super
      end

      private

      def populate_history_from_git
        commit_spec = ENV["RUBOCOP_COMMIT_SPEC"] || "master"

        diff = `git --no-pager diff #{commit_spec}`

        @git_history = ::GitDiffParser.parse(diff).each_with_object({}) do |patch, acc|
          next if patch.changed_line_numbers.empty?

          acc[File.expand_path(patch.file)] = patch.changed_line_numbers
        end
      end

      def file_touched?(file)
        @git_history.key?(file)
      end

      def offenses_from_git_history(file, offenses)
        offenses.select { |offense| @git_history[file].include?(offense.line) }
      end
    end
  end
end
