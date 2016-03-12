require 'BlinkyTape'
require 'color'

class BlinkyPaxos
  attr_accessor :data

  def initialize
    @tape = BlinkyTape.new('/dev/tty.usbmodem1421')
    @data = Array.new(60)
    @data.collect! { Color::RGB.by_name('black') }
  end

  def close
    @tape.close
  end

  def set_color(index, color)
    @data[index] = color
  end

  def update
    for index in 0..@tape.led_count-1
      @tape.send_pixel @data[index].red.to_i, @data[index].green.to_i, @data[index].blue.to_i
    end
    @tape.show
  end

end