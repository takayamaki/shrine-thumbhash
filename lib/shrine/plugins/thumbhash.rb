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
          image = load_image(io)
          image = resize_image(image)
          rgba_array = repack_pixels_to_flattened_rgba_array(image)
          thumb_hash_binary = ::ThumbHash.rgba_to_thumb_hash(
            image.width,
            image.height,
            rgba_array
          )
          Base64.urlsafe_encode64(thumb_hash_binary, padding: false)
        end

        private

        def load_image(io)
          src = ::Vips::Source.new_from_descriptor(io.fileno)
          ::Vips::Image.new_from_source(src, "")
        end

        def resize_image(image)
          return image if image.width <= 100 && image.height <= 100

          scale_factor = [100.fdiv(image.width), 100.fdiv(image.height)].min
          image.resize(scale_factor)
        end

        def repack_pixels_to_flattened_rgba_array(image)
          case image.bands
          when 3
            image.to_enum.flat_map { |line| line.flat_map { |rgb| rgb.push(255) } }
          when 4
            image.to_enum.flat_map(&:flatten)
          else
            raise "Unexpected bands: #{image.bands}"
          end
        end
      end
    end

    register_plugin(:thumbhash, Thumbhash)
  end
end
