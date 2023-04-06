# frozen_string_literal: true

require "shrine/plugins/thumbhash"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  def jpeg_image
    File.open("#{__dir__}/fixtures/horse_silhouette_at_sunrise.jpg", binmode: true)
  end

  def png_image
    File.open("#{__dir__}/fixtures/moon.png", binmode: true)
  end
end
