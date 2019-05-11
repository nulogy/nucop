require "rexml/document"

module Nucop
  module Formatters
    class JUnitFormatter < ::RuboCop::Formatter::BaseFormatter
      # This gives all cops - we really want all _enabled_ cops, but
      # that is difficult to obtain - no access to config object here.
      COPS = RuboCop::Cop::Cop.all

      def started(_target_file)
        @document = REXML::Document.new.tap do |d|
          d << REXML::XMLDecl.new
        end
        @testsuites = REXML::Element.new("testsuites", @document)
        @testsuite = REXML::Element.new("testsuite", @testsuites).tap do |el|
          el.add_attributes("name" => "rubocop")
        end
      end

      def file_finished(file, offences)
        # One test case per cop per file
        COPS.each do |cop|
          cop_offences = offences.select { |offence| offence.cop_name == cop.cop_name }
          unless cop_offences.empty?
            REXML::Element.new("testcase", @testsuite).tap do |f|
              f.attributes["classname"] = file.gsub(/\.rb\Z/, "").gsub("#{Dir.pwd}/", "").tr("/", ".")
              f.attributes["name"]      = "Rubocop: #{cop.cop_name}"
              f.attributes["file"]      = cop.cop_name
              cop_offences.each do |offence|
                REXML::Element.new("failure", f).tap do |e|
                  e.add_text("#{offence.message}\n\n")
                  e.add_text(offence.location.to_s.sub("/usr/src/app/", ""))
                end
              end
            end
          end
        end
      end

      def finished(_inspected_files)
        @document.write(output, 2)
      end
    end
  end
end
