require "nucop/version"

require "rubocop"
require "git_diff_parser"

Dir[File.join(__dir__, "nucop/helpers/**/*.rb")].sort.each { |f| require f }
Dir[File.join(__dir__, "nucop/formatters/**/*.rb")].sort.each { |f| require f }
Dir[File.join(__dir__, "nucop/cops/**/*.rb")].sort.each { |f| require f }

module Nucop
end
