class BlinkyWorkday

  def initialize(blinky_paxos, start_time, end_time)
    @start_time = start_time
    @end_time   = end_time
    @blinky_paxos = blinky_paxos

   end

  def loop
    while true
      now = DateTime.now.to_time.to_i
      e = @end_time - @start_time
      now = now - @start_time

      p = (now.to_f / e.to_f) * 60
      if p < 0
        p = 0
      end

      for index in 0..(p.to_i-1)
        @blinky_paxos.data[index] = Color::RGB.by_name('red')
      end

      for index in p.to_i..(60)
        @blinky_paxos.data[index] = Color::RGB.by_name('black')
      end

      @blinky_paxos.update
      sleep(1)
    end
  end

end