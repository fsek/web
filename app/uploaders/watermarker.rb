require 'mini_magick'

class Watermarker
  def initialize(original_path, watermark_path)
    @original_path = original_path.to_s
    @watermark_path = watermark_path.to_s
  end

  # Accepted options: :gravity
  #
  #   Gravity options: None, Center, East, Forget, NorthEast, North,
  #   NorthWest, SouthEast, South, SouthWest, West, Static
  def watermark!(options = {})
    options[:gravity] ||= 'NorthWest'

    image = MiniMagick::Image.open(@original_path)
    result = image.composite(MiniMagick::Image.open(@watermark_path)) do |c|
      c.gravity options[:gravity]
    end
    result.write @original_path
  end
end
