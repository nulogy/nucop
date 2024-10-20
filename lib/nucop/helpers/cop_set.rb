module Nucop
  module Helpers
    class CopSet
      def initialize(initial_cops = [])
        @cops = Set.new

        add_cops(initial_cops)

        @new_cop_added = false
      end

      def add_cops(cops)
        cops.each(&method(:add_cop))
      end

      # add a single cop to the set
      # if a cops department is already included,
      # the cop is not added (it is part of the department already)
      def add_cop(cop)
        department = find_department(cop)

        return if department && @cops.include?(department)
        return if @cops.include?(cop)

        @cops << cop
        @new_cop_added = true
      end

      def to_a
        @cops.to_a
      end

      def cop_added?
        @new_cop_added
      end

      private

      def find_department(cop)
        return unless cop.include?("/")

        cop.split("/").first
      end
    end
  end
end
