# frozen_string_literal: true

require_relative "../image"
require "mini_magick"

class Shrine # :nodoc:
  module Plugins # :nodoc:
    module Thumbhash # :nodoc:
      module ImageLoader # :nodoc:
        module MiniMagick # :nodoc:
          def self.call(io)
            image = load_image(io)
            image = resize_image(image)
            Thumbhash::Image.new(
              image.width,
              image.height,
              repack_pixels_to_flattened_rgba_array(image)
            )
          end

          def self.load_image(io)
            ::MiniMagick::Image.read(io)
          end

          def self.resize_image(image)
            return image if image.width <= 100 && image.height <= 100

            image.resize("100x100")
          end

          def self.repack_pixels_to_flattened_rgba_array(image)
            image.get_pixels("RGBA").flatten
          end
        end
      end
    end
  end
end
