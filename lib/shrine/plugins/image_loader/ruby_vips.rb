# frozen_string_literal: true

require_relative "../image"
require "ruby-vips"

class Shrine # :nodoc:
  module Plugins # :nodoc:
    module Thumbhash # :nodoc:
      module ImageLoader # :nodoc:
        module RubyVips # :nodoc:
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
            src = ::Vips::Source.new_from_descriptor(io.fileno)
            ::Vips::Image.new_from_source(src, "")
          end

          def self.resize_image(image)
            return image if image.width <= 100 && image.height <= 100

            scale_factor = [100.fdiv(image.width), 100.fdiv(image.height)].min
            image.resize(scale_factor)
          end

          def self.repack_pixels_to_flattened_rgba_array(image)
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
    end
  end
end
