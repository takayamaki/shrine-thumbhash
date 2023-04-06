# frozen_string_literal: true

require "shrine"
require "thumbhash"

class Shrine # :nodoc:
  module Plugins # :nodoc:
    module Thumbhash # :nodoc:
      DEFAULT_OPTIONS = {
        padding: true,
        image_loader: :ruby_vips
      }.freeze

      def self.configure(uploader, **opts)
        uploader.opts[:thumbhash] ||= DEFAULT_OPTIONS.dup
        uploader.opts[:thumbhash].merge!(opts)
        configure_image_loader(uploader.opts[:thumbhash]) if uploader.opts[:thumbhash][:image_loader_class].nil?
      end

      def self.configure_image_loader(opts)
        return unless opts[:image_loader] == :ruby_vips

        require_relative "image_loader/ruby_vips"
        opts[:image_loader] = Shrine::Plugins::Thumbhash::ImageLoader::RubyVips
      end

      module ClassMethods # :nodoc:
        def generate_thumbhash(io)
          image = opts[:thumbhash][:image_loader].call(io)

          ::ThumbHash.rgba_to_thumb_hash(
            image.width,
            image.height,
            image.pixels
          )
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
