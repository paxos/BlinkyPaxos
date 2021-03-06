class BlinkyWorkday

  require_relative 'blinky_rainbow'
  require 'time_difference'

  def initialize(blinky_paxos, start_time, end_time, break_start, break_end)
    @start_time = start_time
    @end_time   = end_time
    @break_start= break_start
    @break_end  = break_end
    @b = blinky_paxos
    @rainbow = BlinkyRainbow.new(blinky_paxos)
   end

  def loop
    while true
      now = DateTime.now
      #now = DateTime.new(DateTime.now.year, DateTime.now.month, DateTime.now.day, 18, 35, 00, '-08:00').to_time.to_i

      if now.saturday? || now.sunday?
        @b.set_color('black')
      else

        if now < @start_time
          # Before work
          @b.brightness = -70
          @rainbow.process
        end

        if now > @start_time && now < @break_start
          # Before Break
          p = time_diff_to_p(now, @start_time, @break_start)
          #@b.brightness = (100-p)*-1
          @b.brightness = 0
          @b.set_percentage('red', 'green', p)
        end

        if now > @start_time && now > @break_start && now < @break_end
          # During break
          @b.brightness = 0
          @rainbow.process
        end

        if now > @start_time && now > @break_end && now < @end_time
          # After Break
          p = time_diff_to_p(now, @break_end, @end_time)
          @b.brightness = 0
          @b.set_percentage('red', 'green', p)
        end

        if now > @end_time
          # After Work
          @b.brightness = -70
          @rainbow.process
        end
      end

      @b.show
    end
  end

  def time_diff_to_p(now, start_time, end_time)
    e = TimeDifference.between(start_time, end_time).in_seconds
    a = TimeDifference.between(now, start_time).in_seconds
    p = (a/e)*100
  end

end