# class to count the number of cops from a list of RuboCop "only" options
# i.e. it accounts for whole "Departments"
#
# Examaples:
# "Style/Blah" is 1 cops
# "Layout" may represent 70 cops
module Nucop
  module Helpers
    class CopCounter
      def self.count(all_cops, cops_or_departments)
        new(all_cops).count(cops_or_departments)
      end

      def initialize(cops)
        @cops_by_department = group_by_department(cops)
      end

      def count(cops_or_departments)
        cops_or_departments
          .map do |cop_or_department|
          if department?(cop_or_department)
            @cops_by_department.fetch(cop_or_department, []).length
          else
            1
          end
        end
          .reduce(0, &:+)
      end

      private

      def group_by_department(cop_names)
        cop_names.group_by do |cop_name|
          if department?(cop_name)
            raise "Expected fully-qualified cops by name (i.e. Department/Cop). Got: #{cop_name}"
          end

          department(cop_name)
        end
      end

      def department?(cop_name)
        !cop_name.include?("/")
      end

      def department(cop_name)
        cop_name.split("/").first
      end
    end
  end
end
