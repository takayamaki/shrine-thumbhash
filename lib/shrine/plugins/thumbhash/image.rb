# frozen_string_literal: true

class Shrine # :nodoc:
  module Plugins # :nodoc:
    module Thumbhash # :nodoc:
      class Image # :nodoc:
        attr_reader :width, :height, :pixels

        def initialize(width, height, pixels)
          @width = width
          @height = height
          @pixels = pixels
        end
      end
    end
  end
end
