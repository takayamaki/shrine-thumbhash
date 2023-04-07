# frozen_string_literal: true

require "bundler/setup"
require "shrine/plugins/thumbhash/image_loader/mini_magick"

RSpec.describe Shrine::Plugins::Thumbhash::ImageLoader::MiniMagick do
  it "Thumbhash::ImageLoader::MiniMagick.call returns a Ruby object that has width, height and pixels" do
    image = Shrine::Plugins::Thumbhash::ImageLoader::MiniMagick.call(jpeg_image)
    aggregate_failures do
      expect(image.width).to eq(100)
      expect(image.height).to eq(59)
      expect(image.pixels).to be_a(Array)
    end
  end

  it "When specify :mini_magick to image_loader option, opts object has ImageLoader::MiniMagick as image loader" do
    shrine_class = Class.new(Shrine)
    shrine_class.class_eval do
      plugin :thumbhash, image_loader: :mini_magick
    end

    aggregate_failures do
      expect(shrine_class.opts[:thumbhash][:image_loader])
        .to eq(Shrine::Plugins::Thumbhash::ImageLoader::MiniMagick)
      expect(Base64.urlsafe_encode64(shrine_class.generate_thumbhash(jpeg_image), padding: false))
        .to eq "4igaZIp2iHiPeHeGd3d2hFAmCA"
      expect(Base64.urlsafe_encode64(shrine_class.generate_thumbhash(png_image), padding: false))
        .to eq "IwiGBQA4AsyTWqnbZQZvQ2QGB1eHiIB4Vw"
    end
  end
end
