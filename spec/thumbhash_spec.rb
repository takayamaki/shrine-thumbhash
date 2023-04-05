# frozen_string_literal: true

require "bundler/setup"
require "shrine"
require "shrine/plugins/thumbhash"

RSpec.describe Shrine::Plugins::Thumbhash do
  it "has a version number" do
    expect(Shrine::Plugins::Thumbhash::VERSION).not_to be_nil
  end

  let :shrine_class do
    shrine_class = Class.new(Shrine)
    shrine_class.class_eval { plugin :thumbhash }
    shrine_class
  end

  def jpeg_image
    File.open("#{__dir__}/fixtures/horse_silhouette_at_sunrise.jpg", binmode: true)
  end

  def png_image
    File.open("#{__dir__}/fixtures/moon.png", binmode: true)
  end

  describe "ClassMethod" do
    describe "generate_thumbhash" do
      it "Shrine.generate_thumbhash returns thumbhash from image as binary" do
        aggregate_failures do
          expect(Base64.urlsafe_encode64(shrine_class.generate_thumbhash(jpeg_image), padding: false))
            .to eq "4igaZIp2iHiPeHeGd3d2hFAmCA"
          expect(Base64.urlsafe_encode64(shrine_class.generate_thumbhash(png_image), padding: false))
            .to eq "IwiGBQA4AsyTWqnbZQZuU2QGB1d3iIB4WA"
        end
      end
    end
  end
end
