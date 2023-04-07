# frozen_string_literal: true

require "bundler/setup"
require "shrine"
require "shrine/storage/memory"
require "shrine/plugins/thumbhash"
require "shrine/plugins/thumbhash/image_loader/ruby_vips"

RSpec.describe Shrine::Plugins::Thumbhash::ImageLoader::RubyVips do # rubocop:disable Metrics/BlockLength
  it "Thumbhash::ImageLoader::RubyVips.call returns a Ruby object that has width, height and pixels" do
    image = Shrine::Plugins::Thumbhash::ImageLoader::RubyVips.call(jpeg_image)
    aggregate_failures do
      expect(image.width).to eq(100)
      expect(image.height).to eq(59)
      expect(image.pixels).to be_a(Array)
    end
  end

  it "When specify :mini_magick to image_loader option, opts object has ImageLoader::RubyVips as image loader" do
    shrine_class = Class.new(Shrine)
    shrine_class.class_eval do
      plugin :thumbhash, image_loader: :ruby_vips
    end

    aggregate_failures do
      expect(shrine_class.opts[:thumbhash][:image_loader])
        .to eq(Shrine::Plugins::Thumbhash::ImageLoader::RubyVips)
      expect(Base64.urlsafe_encode64(shrine_class.generate_thumbhash(jpeg_image), padding: false))
        .to eq "4igaZIp2iHiPeHeGd3d2hFAmCA"
      expect(Base64.urlsafe_encode64(shrine_class.generate_thumbhash(png_image), padding: false))
        .to eq "IwiGBQA4AsyTWqnbZQZuU2QGB1d3iIB4WA"
    end
  end

  it "ImageLoader::RubyVips is default of image_loader option" do
    shrine_class = Class.new(Shrine)
    shrine_class.class_eval do
      plugin :thumbhash
    end

    expect(shrine_class.opts[:thumbhash][:image_loader])
      .to eq(Shrine::Plugins::Thumbhash::ImageLoader::RubyVips)
  end
end
