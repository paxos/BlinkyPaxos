require 'BlinkyTape'
require 'color'

class BlinkyPaxos
  attr_accessor :data, :animations, :brightness
  attr_reader :led_count

  def initialize
    @tape = BlinkyTape.new('/dev/tty.usbmodem1421')
    @brightness = 0
    @led_count = @tape.led_count
    @data = Array.new(60)
    @data.collect! { color('black') }
    @animations = []

    # clear to black
    self.show
  end

  def close
    @tape.close
  end

  def set_color(color_string)
    @data.collect! { color(color_string) }
  end

  def show
    (0..@tape.led_count-1).each { |index|
      @tape.send_pixel @data[index].red.to_i, @data[index].green.to_i, @data[index].blue.to_i
    }
    @tape.show
  end

  # TODO: this overwrites pixels yet
  def add_animation(start, target, time)
    @animations << {
        :start => start,
        :target => target,
        :time => time
    }
  end

  def process(show = true)
    self.animations.each do |animation|
      next if animation[:target] == animation[:start]

      if animation[:target] > animation[:start]
        tmp = self.data[animation[:start]+1]
        self.data[animation[:start]+1] = self.data[animation[:start]]
        self.data[animation[:start]] = tmp
        animation[:start] = animation[:start] + 1
      else
        tmp = self.data[animation[:start]-1]
        self.data[animation[:start]-1] = self.data[animation[:start]]
        self.data[animation[:start]] = tmp
        animation[:start] = animation[:start] - 1
      end
    end

    self.show if show
  end

  def color(color)
    if color.is_a? String
      Color::RGB.by_name(color).adjust_brightness(@brightness)
    else
      color.adjust_brightness(@brightness)
    end
  end

  def set_spot_pixel(color, position)
    self.data[position] = color(color)
    (1..10).each do |index|
      self.data[position+index] = color(color).adjust_brightness(-10*index)
      self.data[position-index] = color(color).adjust_brightness(-15*index)
    end
    self.show
  end

  def set_percentage(color, percentage, background_color = 'black', reverse = false)
    max = ((@tape.led_count.to_f / 100) * percentage).round - 1
    @data.collect! { color(background_color) }
    (0..max).each { |index|
      @data[index] = color(color)
    }
    self.show
  end
end