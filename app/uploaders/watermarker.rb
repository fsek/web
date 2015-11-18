require 'mini_magick'

class Watermarker
  def initialize(original_path)
    @original_path = original_path.to_s
  end

  # Accepted options: :gravity
  #
  #   Gravity options: None, Center, East, Forget, NorthEast, North,
  #   NorthWest, SouthEast, South, SouthWest, West, Static
  def watermark!(options = {})
    watermark_path = Rails.root.join('app/assets/images/layout/watermark.png')

    options[:gravity] ||= 'SouthEast'
    image = MiniMagick::Image.open(@original_path)
    watermark = MiniMagick::Image.open(watermark_path)
    height = image[:height] * 0.20

    watermark.resize(%(x#{height}))

    result = image.composite(watermark, 'png') do |c|
      c.gravity options[:gravity]
      c.geometry %(+#{height / 2}+#{height / 2})
    end
    result.write @original_path
  end
end
