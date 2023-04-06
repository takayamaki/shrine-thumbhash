# frozen_string_literal: true

require_relative "lib/shrine/plugins/thumbhash/version"

Gem::Specification.new do |spec|
  spec.name = "shrine-thumbhash"
  spec.version = Shrine::Plugins::Thumbhash::VERSION
  spec.authors = ["takayamaki / fusagiko"]
  spec.email = ["24884114+takayamaki@users.noreply.github.com"]

  spec.summary = "Shrine plugin for generate Thumbhash from image attachments"
  spec.homepage = "https://github.com/takayamaki/shrine-thumbhash"
  spec.required_ruby_version = ">= 2.6"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/takayamaki/shrine-thumbhash"
  spec.metadata["changelog_uri"] = "https://github.com/takayamaki/shrine-thumbhash/releases"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "shrine", "~> 3.0"
  spec.add_dependency "thumbhash", "~> 0.0.1"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata["rubygems_mfa_required"] = "true"
end
