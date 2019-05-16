require "thor"
require "open3"

ENFORCED_COPS_FILE = ".rubocop.enforced.yml"
RUBOCOP_TODO_FILE = ".rubocop_todo.yml"
RUBOCOP_BACKLOG_FILE = ".rubocop.backlog.yml"

module Nucop
  class CLI < Thor
    desc "diff_enforced", "run rubocop on the current diff using enforced cops only (see '#{ENFORCED_COPS_FILE}')"
    method_option "commit-spec", default: "origin/master", desc: "the commit used to determine the diff."
    method_option "auto-correct", type: :boolean, default: false, desc: "runs rubocop with auto-correct option"
    method_option "junit_report", type: :string, default: "", desc: "runs rubocop with junit formatter option"
    def diff_enforced
      invoke :diff, nil, options.merge(only: cops_to_enforce.join(","))
    end

    desc "diff", "run rubocop on the current diff"
    method_option "commit-spec", default: "origin/master", desc: "the commit used to determine the diff."
    method_option "only", desc: "run only specified cop(s) and/or cops in the specified departments"
    method_option "auto-correct", type: :boolean, default: false, desc: "runs rubocop with auto-correct option"
    method_option "ignore", type: :boolean, default: true, desc: "ignores files specified in development/rubocop/.diffignore"
    method_option "added-only", type: :boolean, default: false, desc: "runs rubocop only on files that have been added (not on files that have been modified)"
    method_option "exit", type: :boolean, default: true, desc: "disable to prevent task from exiting. used by other thor tasks when invoking this task, to prevent parent task from exiting"
    def diff
      puts "Running on files changed relative to '#{options[:"commit-spec"]}' (specify using the 'commit-spec' option)"
      diff_filter = options[:"added-only"] ? "A" : "d"
      diff_base = capture_std_out("git merge-base HEAD #{options[:"commit-spec"]}").chomp

      diff_files, diff_status = Open3.capture2("git diff #{diff_base} --diff-filter=#{diff_filter} --name-only | grep \"\\.rb$\"")

      if diff_status != 0
        if options[:exit]
          puts "There are no rb files present in diff. Exiting."
          exit 0
        else
          puts "There are no rb files present in diff."
          # Returns true for the integrate task which should continue (not exit)
          return true
        end
      end

      non_ignored_diff_files, non_ignored_diff_status = Open3.capture2("grep -v -f development/rubocop/.diffignore", stdin_data: diff_files)

      if non_ignored_diff_status != 0
        if options[:exit]
          puts "There are no non-ignored rb files present in diff. Exiting."
          exit 0
        else
          puts "There are no non-ignored rb files present in diff."
          # Returns true for the integrate task which should continue (not exit)
          return true
        end

      end

      files = options[:ignore] ? non_ignored_diff_files : diff_files

      no_violations_detected = invoke :rubocop, [multi_line_to_single_line(files)], options

      exit 1 unless no_violations_detected
      return true unless options[:exit]
      exit 0
    end

    desc "rubocop", "run rubocop on files provided"
    method_option "only", desc: "run only specified cop(s) and/or cops in the specified departments"
    method_option "auto-correct", type: :boolean, default: false, desc: "runs rubocop with auto-correct option"
    method_option "exclude-backlog", type: :boolean, default: false, desc: "when true, uses config which excludes current violations in #{RUBOCOP_TODO_FILE}"
    def rubocop(files = nil)
      print_cops_being_run(options[:only])
      config_file = options[:"exclude-backlog"] ? ".rubocop.yml" : RUBOCOP_BACKLOG_FILE
      junit_report_path = options[:"junit_report"]
      junit_report_options = junit_report_path.to_s.empty? ? "" : "--format Nucop::Formatters::JUnitFormatter --out #{junit_report_path} --format progress"

      system("bundle exec rubocop --require rubocop-rspec --require rubocop-performance #{junit_report_options} --force-exclusion --config #{config_file} #{pass_through_option(options, 'auto-correct')} #{pass_through_flag(options, 'only')} #{files}")
    end

    desc "regen_backlog", "update the Rubocop backlog (#{RUBOCOP_TODO_FILE}), disabling offending files and excluding all cops with over 500 violating files."
    def regen_backlog
      regenerate_rubocop_todos
      update_enforced_cops
    end

    desc "update_enforced", "update the '#{ENFORCED_COPS_FILE}' file with cops that no longer have violations"
    def update_enforced
      update_enforced_cops
    end

    desc "modified_lines", "display RuboCop violations for ONLY modified lines"
    method_option "commit-spec", default: "master", desc: "the commit used to determine the diff."

    def modified_lines
      diff_files, diff_status = Open3.capture2("git diff #{options[:'commit-spec']} --diff-filter=d --name-only | grep \"\\.rb$\"")

      exit 1 unless diff_status.exitstatus.zero?

      command = [
        "bundle exec rubocop",
        "--format Nucop::Formatters::GitDiffFormatter",
        "--config #{RUBOCOP_BACKLOG_FILE}",
        multi_line_to_single_line(diff_files).to_s
      ].join(" ")

      # HACK: use ENVVAR to parameterize GitDiffFormatter
      system({ "RUBOCOP_COMMIT_SPEC" => options[:"commit-spec"] }, command)
    end

    desc "ready_for_promotion", "display the next n cops with the fewest offenses"
    method_option "n", type: :numeric, default: 1, desc: "number of cops to display"
    def ready_for_promotion
      finder = ::Nucop::Helpers::NextCopForPromotion.new(RUBOCOP_TODO_FILE)
      todo_config = YAML.load_file(RUBOCOP_TODO_FILE)

      puts "The following cop(s) are ready to be promoted to enforced. Good luck!"
      puts "Remember to run `nucop:regen_backlog` to capture your hard work."
      puts
      finder.find(options["n"].to_i).each do |todo|
        puts "#{todo.name} with #{todo.offenses} offenses:"
        puts

        files = todo_config.fetch(todo.name, {}).fetch("Exclude", [])

        system("bundle exec rubocop --config #{RUBOCOP_BACKLOG_FILE} --only #{todo.name} #{files.join(' ')}")
        puts("*" * 100) if options["n"] > 1
        puts
      end
    end

    private

    # some cops cannot be used with the --only option and will raise an error
    # this filters them out
    def cops_to_enforce
      cops = enforced_cops

      cops.delete("Lint/UnneededCopDisableDirective")

      cops
    end

    def enforced_cops
      @enforced_cops ||= YAML.load_file(ENFORCED_COPS_FILE)
    end

    def capture_std_out(command, error_message = nil, stdin_data = nil)
      std_out, std_error, status = Open3.capture3(command, stdin_data: stdin_data)
      print_errors_and_exit(std_error, error_message) unless status.success?

      std_out
    end

    def print_errors_and_exit(std_error, message = "An error has occurred")
      warn message
      puts std_error
      puts "Exiting"
      exit 1
    end

    def print_cops_being_run(only_option)
      if only_option
        enforced_cops_count = ::Nucop::Helpers::CopCounter.count(enabled_cops, only_option.split(","))
        puts "Running with a force of #{enforced_cops_count} cops. See '#{ENFORCED_COPS_FILE}' for more details."
      else
        puts "Running all cops (specify using the 'only' option)"
      end
    end

    def multi_line_to_single_line(str)
      str.split(/\n+/).join(" ")
    end

    def pass_through_flag(options, option)
      pass_through_option(options, option, true)
    end

    def pass_through_option(options, option, is_flag_option = false)
      return nil unless options[option]
      "--#{option} #{options[option] if is_flag_option}"
    end

    def files_changed_since(commit_spec)
      `git diff #{commit_spec} HEAD --name-only`
        .split("\n")
        .select { |e| e.end_with?(".rb") }
    end

    def regenerate_rubocop_todos
      puts "Regenerating '#{RUBOCOP_TODO_FILE}' (with output written to '.rubocop.backlog.txt')."
      puts "Please be patient..."

      options = [
        "--auto-gen-config",
        "--config #{RUBOCOP_BACKLOG_FILE}",
        "--exclude-limit 500",
        "--out .rubocop.backlog.txt"
      ]

      rubocop_command = "DISABLE_SPRING=1 bundle exec rubocop #{options.join(' ')}"

      system(rubocop_command)

      # RuboCop wants to inherit from our todos (RUBOCOP_TODO_FILE) in our backlog configuration file (RUBOCOP_BACKLOG_FILE)
      # However, that means the next time we try to update our backlog, it will NOT include the violations recorded as todo
      # For now, we ignore any changes in our backlog config
      system("git checkout #{RUBOCOP_BACKLOG_FILE}")
    end

    def update_enforced_cops
      puts "Updating enforced cops list..."

      current_enforced_cops = ::Nucop::Helpers::CopSet.new(enforced_cops)
      cops_without_violations.each do |cop|
        current_enforced_cops.add_cop(cop)
      end

      if current_enforced_cops.cop_added?
        File.open(ENFORCED_COPS_FILE, "w+") do |f|
          f.write(current_enforced_cops.to_a.sort.to_yaml)
        end
        puts "Updated '#{ENFORCED_COPS_FILE}'!"
      else
        puts "No new cops are clear of violations"
      end
    end

    def cops_without_violations
      cops_with_violations = YAML.load_file(RUBOCOP_TODO_FILE).map(&:first)

      enabled_cops - cops_with_violations
    end

    def enabled_cops
      YAML.load(`bundle exec rubocop --show-cops`).select { |_, config| config["Enabled"] }.map(&:first)
    end
  end
end
