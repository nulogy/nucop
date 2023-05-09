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
    "bug_tracker_uri" => "https://github.com/nulogy/nucop/issues",
    "rubygems_mfa_required" => "true"
  }

  spec.bindir = "bin"
  spec.executables = "nucop"
  spec.files = Dir["lib/**/*"]
  spec.require_paths = ["lib"]

  spec.add_dependency "git_diff_parser", "~> 4.0"
  spec.add_dependency "rubocop", "~> 1.46"
  spec.add_dependency "rubocop-factory_bot", "~> 2.22"
  spec.add_dependency "rubocop-graphql", "~> 1.0"
  spec.add_dependency "rubocop-performance", "~> 1.16"
  spec.add_dependency "rubocop-rails", "~> 2.18"
  spec.add_dependency "rubocop-rake", "~> 0.6"
  spec.add_dependency "rubocop-rspec", "~> 2.18"
  spec.add_dependency "rubocop-rubycw", "~> 0.1"
  spec.add_dependency "rubocop-thread_safety", "~> 0.4"
  spec.add_dependency "ruby-progressbar", "~> 1.11"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.12"
end
