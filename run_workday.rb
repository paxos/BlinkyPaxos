#!/usr/bin/ruby

require 'BlinkyTape'
require 'color'
require 'date'
require 'active_support/all' # Make x.days.ago available

require_relative 'lib/blinky_paxos.rb'
require_relative 'lib/blinky_workday'
require_relative 'lib/blinky_rainbow'

def workday
  p = BlinkyPaxos.new

  #start_time = DateTime.new(DateTime.now.year, DateTime.now.month, DateTime.now.day, 22, 49, 0, '-08:00').to_time.to_i
  #end_time = DateTime.new(DateTime.now.year, DateTime.now.month, DateTime.now.day, 22, 50, 0, '-08:00').to_time.to_i

  start_time    = Time.parse ('2016-03-13 09:00:00')
  break_start   = Time.parse ('2016-03-13 11:45:00')
  break_end     = Time.parse ('2016-03-13 13:00:00')
  end_time      = Time.parse ('2016-03-13 18:00:00')

  w = BlinkyWorkday.new(p, start_time, end_time, break_start, break_end)
  while true
    w.loop
    sleep 1
  end
  p.close
end

workday