#!/usr/bin/ruby

require 'BlinkyTape'
require 'color'
require 'date'

require_relative 'lib/blinky_paxos.rb'
require_relative 'lib/blinky_workday'

def test_workday
  p = BlinkyPaxos.new

  start_time = DateTime.new(DateTime.now.year, DateTime.now.month, DateTime.now.day, 18, 00, 0, '-08:00').to_time.to_i
  end_time = DateTime.new(DateTime.now.year, DateTime.now.month, DateTime.now.day, 19, 00, 0, '-08:00').to_time.to_i

  w = BlinkyWorkday.new(p, start_time, end_time)
  while true
    w.loop
    sleep 1
  end

  p.close
end

def test_solid_color
  p = BlinkyPaxos.new
  p.brightness = -80
  p.set_color('green')
  p.show
  p.close
end

def test_colors
  p = BlinkyPaxos.new

  (0..p.led_count).each { |index|
    p.data[index] = Color::RGB.by_name('blue')
  }
  p.show


  while true
    # First gets random color
    if rand(100) > 10
      random_color = Color::RGB.new(rand(255), rand(255), rand(255))
      p.data[0] = random_color
    end

    (0..p.led_count).each { |index|
      if index > 0 && index < 60
        if p.data[index] != p.data[index-1]
          p.data[index] = p.data[index-1]
          p.show
        end

      end

    }

    sleep(0.01)

  end

  p.close
end

def test_fade
  p = BlinkyPaxos.new

  (0..100).each { |index|
    p.brightness = index * -1
    p.set_color('green')
    p.show
  }

  100.downto(0).each { |index|
    p.brightness = index * -1
    p.set_color('green')
    p.show
  }

  p.close
end

def test_animation
  p = BlinkyPaxos.new
  #p.brightness = -90

  p.data[0] = p.color('green')
 # p.data[59] = p.color('red')

  p.add_animation(0, 59, 1)
 # p.add_animation(59, 0, 1)

  while true
    p.process(true)
 #   sleep 0.01
  end

  p.close
end

def test_spot_pixel
  p = BlinkyPaxos.new

  p.set_spot_pixel('red', 10)
  p.close
end

test_spot_pixel
