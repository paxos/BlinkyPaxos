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

  start_time    = Time.current.change(hour: 9, minute: 0, sec: 0)
  break_start   = Time.current.change(hour: 11, min: 45, sec: 0)
  break_end     = Time.current.change(hour: 13, min: 0, sec: 0)
  end_time      = Time.current.change(hour: 18, min: 0, sec: 0)

  w = BlinkyWorkday.new(p, start_time, end_time, break_start, break_end)
  while true
    begin
      w.loop
    rescue Exception => e
      p.close

      until BlinkyPaxos.tape_available?
        sleep 1
      end

      p = BlinkyPaxos.new
      w = BlinkyWorkday.new(p, start_time, end_time, break_start, break_end)
      retry
    end
    sleep 1
  end


  p.close
end

workday