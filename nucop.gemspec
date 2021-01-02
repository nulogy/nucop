lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "nucop/version"

Gem::Specification.new do |spec|
  spec.name = "nucop"
  spec.version = Nucop::VERSION
  spec.authors = ["Jason Schweier"]
  spec.email = ["jasons@nulogy.com"]
  spec.summary = "Nulogy's implementation of RuboCop, including custom cops and additional tooling."
  spec.licenses = ["MIT"]
  spec.homepage = "https://rubygems.org/gems/nucop"

  spec.metadata = {
    "homepage_uri" => "https://github.com/nulogy/nucop",
    "changelog_uri" => "https://github.com/nulogy/nucop/blob/master/CHANGELOG.md",
    "source_code_uri" => "https://github.com/nulogy/nucop",
    "bug_tracker_uri" => "https://github.com/nulogy/nucop/issues"
  }

  spec.bindir = "bin"
  spec.executables = "nucop"
  spec.files = Dir["lib/**/*"]
  spec.test_files = Dir["spec/**/*"]
  spec.require_paths = ["lib"]

  spec.add_dependency "git_diff_parser", "3.2"
  spec.add_dependency "rubocop", "1.7.0"
  spec.add_dependency "rubocop-performance", "1.9.1"
  spec.add_dependency "rubocop-rails", "2.9.1"
  spec.add_dependency "rubocop-rake", "0.5.1"
  spec.add_dependency "rubocop-rspec", "2.1.0"
  spec.add_dependency "ruby-progressbar", "~> 1.10"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.9"
end
