module Nucop
  module Helpers
    class NextCopForPromotion
      Todo = Struct.new(:name, :offenses)

      def initialize(todo_filepath)
        @todo_filepath = todo_filepath
        extract_todos
        sort_todos_by_offense_count
      end

      def find(how_many = 5)
        @todos.take(how_many)
      end

      private

      def extract_todos
        @todos =
          extract_offense_counts_and_names
            .each_slice(2)
            .map { |count, name| Todo.new(name, count.to_i) }
      end

      def extract_offense_counts_and_names
        data = []

        each_line do |line|
          if (count_match = line.match(/Offense count: (\d+)/))
            data << count_match.captures.first
          end

          if (name_match = line.match(/^(\w+\/\w+):$/))
            data << name_match.captures.first
          end
        end

        data
      end

      def each_line
        File.open(@todo_filepath, "r") do |file|
          file.each_line do |line|
            yield line
          end
        end
      end

      def sort_todos_by_offense_count
        @todos.sort! { |i, j| i.offenses <=> j.offenses }
      end
    end
  end
end
