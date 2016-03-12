#!/usr/bin/ruby

require 'BlinkyTape'
require 'color'
require 'date'

require_relative 'lib/blinky_paxos.rb'
require_relative 'lib/blinky_workday'

p = BlinkyPaxos.new

start_time = DateTime.new(DateTime.now.year, DateTime.now.month, DateTime.now.day, 18, 19, 0, '-08:00').to_time.to_i
end_time = DateTime.new(DateTime.now.year, DateTime.now.month, DateTime.now.day, 18, 20, 0, '-08:00').to_time.to_i

w = BlinkyWorkday.new(p, start_time, end_time)
while true
  w.loop
  sleep 1
end


p.close