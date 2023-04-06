# frozen_string_literal: true

require "bundler/setup"

RSpec.describe "Custom image loader implementation" do
  it "Developer can use own custom implementation as image loader" do
    custom_implementation = Module.new

    shrine_class = Class.new(Shrine)
    shrine_class.class_eval do
      plugin :thumbhash, image_loader: custom_implementation
    end

    expect(shrine_class.opts[:thumbhash][:image_loader]).to eq(custom_implementation)
  end
end
