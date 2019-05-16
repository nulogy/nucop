require "nucop/version"

require "rubocop"
require "git_diff_parser"

Dir[File.join(__dir__, "nucop/helpers/**/*.rb")].each { |f| require f }
Dir[File.join(__dir__, "nucop/formatters/**/*.rb")].each { |f| require f }
Dir[File.join(__dir__, "nucop/cops/**/*.rb")].each { |f| require f }

module Nucop
end
