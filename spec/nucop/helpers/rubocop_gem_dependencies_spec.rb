require "rubygems"

RSpec.describe Nucop::Helpers::RubocopGemDependencies do
  subject(:gem_dependencies) { described_class }

  let(:gemspec) { Gem::Specification.load("nucop.gemspec") }

  it "checks that the known dependencies agree with the dependencies listed in the nucop.gemspec" do
    gemspec_gems = gemspec.runtime_dependencies.map(&:name).filter { |name| name.start_with?("rubocop") }.sort
    cli_gems = (gem_dependencies.rubocop_gems + gem_dependencies.rubocop_plugins).sort

    expect(gemspec_gems).to eq(cli_gems)
  end
end
