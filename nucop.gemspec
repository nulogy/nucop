lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "nucop/version"

Gem::Specification.new do |spec|
  spec.name    = "nucop"
  spec.version = Nucop::VERSION
  spec.authors = ["Jason Schweier"]
  spec.email   = ["jasons@nulogy.com"]
  spec.summary = "Nulogy's implementation of RuboCop, including custom cops and additional tooling."
  spec.files   = Dir["lib/**/*"]
  spec.test_files = Dir["spec/**/*"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake", "12.3.2"
  spec.add_development_dependency "rspec", "3.8.0"

  spec.add_dependency "git_diff_parser", "3.1"
  spec.add_dependency "rubocop", "0.68.1"
  spec.add_dependency "rubocop-performance", "1.1.0"
  spec.add_dependency "rubocop-rspec", "1.32.0"
  spec.add_dependency "ruby-progressbar", "1.10.0"
end
