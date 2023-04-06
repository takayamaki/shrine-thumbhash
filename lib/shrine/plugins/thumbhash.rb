# frozen_string_literal: true

require "shrine"
require "thumbhash"
require "ruby-vips"

class Shrine # :nodoc:
  module Plugins # :nodoc:
    module Thumbhash # :nodoc:
      DEFAULT_OPTIONS = {
        padding: true
      }.freeze

      def self.configure(uploader, **opts)
        uploader.opts[:thumbhash] ||= DEFAULT_OPTIONS.dup
        uploader.opts[:thumbhash].merge!(opts)
      end

      module ClassMethods # :nodoc:
        def generate_thumbhash(io)
          image = load_image(io)
          image = resize_image(image)
          rgba_array = repack_pixels_to_flattened_rgba_array(image)
          ::ThumbHash.rgba_to_thumb_hash(
            image.width,
            image.height,
            rgba_array
          )
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

      module InstanceMethods # :nodoc:
        def extract_metadata(io, **options)
          thumbhash = self.class.generate_thumbhash(io)
          super.merge!(encode_thumbhash_as_base64(thumbhash))
        end

        private

        def encode_thumbhash_as_base64(thumbhash)
          if self.class.opts[:thumbhash][:padding]
            {
              "thumbhash" => Base64.strict_encode64(thumbhash),
              "thumbhash_urlsafe" => Base64.urlsafe_encode64(thumbhash)
            }
          else
            {
              "thumbhash" => Base64.strict_encode64(thumbhash).gsub!("=", ""),
              "thumbhash_urlsafe" => Base64.urlsafe_encode64(thumbhash, padding: false)
            }
          end
        end
      end

      module FileMethods # :nodoc:
        def thumbhash
          metadata["thumbhash"]
        end

        def thumbhash_urlsafe
          metadata["thumbhash_urlsafe"]
        end
      end
    end

    register_plugin(:thumbhash, Thumbhash)
  end
end
