class BlinkyRainbow

  require 'color'
  require_relative 'blinky_paxos.rb'

  RAINBOW_COLOR_LENGTH = 20 # Rainbow Resolution
  NUMBER_OF_RAINBOW_COLORS = 8

  attr_accessor :pixel_offset

  def initialize(blinky_paxos)
    @blinky_paxos = blinky_paxos
    @pixel_offset = 15 # Rainbow Offset of each Pixel
    @rainbow_colors = [
        @blinky_paxos.color(Color::RGB.by_name('red')),
        @blinky_paxos.color(Color::RGB.by_name('orange')),
        @blinky_paxos.color(Color::RGB.by_name('yellow')),
        @blinky_paxos.color(Color::RGB.by_name('green')),
        @blinky_paxos.color(Color::RGB.by_name('blue')),
        @blinky_paxos.color(Color::RGB.by_name('indigo')),
        @blinky_paxos.color(Color::RGB.by_name('violet')),
        @blinky_paxos.color(Color::RGB.by_name('white'))
    ]
    @frame = 0.0
    @rainbow = Array.new(RAINBOW_COLOR_LENGTH*NUMBER_OF_RAINBOW_COLORS)

    (0..@rainbow_colors.length-1).each do |index|
      (0..RAINBOW_COLOR_LENGTH-1).each do |color|
        current_color = @rainbow_colors[index]
        next_color = @rainbow_colors[index+1]
        next_color = @rainbow_colors[0] if next_color.nil?

        i = (index)*RAINBOW_COLOR_LENGTH+color

        @rainbow[i] = next_color.mix_with(current_color, color*(100/RAINBOW_COLOR_LENGTH)) # Todo: calc 10
      end
    end

    while @rainbow.count < @blinky_paxos.led_count
      @rainbow.concat(@rainbow)
    end
  end

  def process
    @frame = @frame + 1
    @blinky_paxos.data.each_index { |index|
      @blinky_paxos.data[index] = @blinky_paxos.color(@rainbow.rotate(@frame+(index*@pixel_offset))[0])
    }
  end

end