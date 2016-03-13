class BlinkyWorkday

  def initialize(blinky_paxos, start_time, end_time, break_start, break_end)
    @start_time = start_time
    @end_time   = end_time
    @break_start= break_start
    @break_end  = break_end
    @b = blinky_paxos

   end

  def loop
    while true
      now = DateTime.now.to_time.to_i
     #now = DateTime.new(DateTime.now.year, DateTime.now.month, DateTime.now.day, 18, 35, 00, '-08:00').to_time.to_i
      e = @end_time - @start_time
      now = now - @start_time

      p = (now.to_f / e.to_f) * 60
      return if p < 0
      if p > 59
        p = 59
      end

      c = Color::RGB.new
      c.red = rand(255)
      c.green = rand(255)
      c.blue = rand(255)

      (0..(p.to_i-1)).each { |index|
        @b.data[index] = Color::RGB.by_name('green').adjust_brightness(-80)
      }
      @b.data[p.to_i] = c

      @b.show
      sleep(1)
    end
  end

end