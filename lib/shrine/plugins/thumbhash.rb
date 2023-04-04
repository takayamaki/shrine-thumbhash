# frozen_string_literal: true

require "shrine"
require "thumbhash"
require "ruby-vips"

class Shrine # :nodoc:
  module Plugins # :nodoc:
    module Thumbhash # :nodoc:
      DEFAULT_OPTIONS = {}.freeze

      def self.configure(uploader, **opts)
        uploader.opts[:thumbhash] ||= DEFAULT_OPTIONS.dup
        uploader.opts[:thumbhash].merge!(opts)
      end

      module ClassMethods # :nodoc:
        def generate_thumbhash(io)
          src = ::Vips::Source.new_from_descriptor(io.fileno)
          image = ::Vips::Image.new_from_source(src, "")
          scale_factor = [100.fdiv(image.width), 100.fdiv(image.height)].min
          image = image.resize(scale_factor)
          rgba_array = case image.bands
                       when 3
                         image.to_enum.flat_map { |line| line.flat_map { |rgb| rgb.push(255) } }
                       when 4
                         image.to_enum.flat_map(&:flatten)
                       else
                         raise "Unexpected bands: #{image.bands}"
                       end
          thumb_hash_binary = ::ThumbHash.rgba_to_thumb_hash(
            image.width,
            image.height,
            rgba_array
          )
          Base64.urlsafe_encode64(thumb_hash_binary, padding: false)
        end
      end
    end

    register_plugin(:thumbhash, Thumbhash)
  end
end
