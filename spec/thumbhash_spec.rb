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

  def image
    File.open("#{__dir__}/fixtures/horse_silhouette_at_sunrise.jpg", binmode: true)
  end

  describe "ClassMethod" do
    describe "generate_thumbhash" do
      it "Shrine.generate_thumbhash returns thumbhash from image" do
        expect(shrine_class.generate_thumbhash(image)).to eq "4igaZIp2iHiPeHeGd3d2hFAmCA"
      end
    end
  end
end
