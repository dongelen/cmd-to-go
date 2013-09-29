class Schedule
  attr_accessor :spots
  def breaks 
    [cbreak (2,"2 afspraken"), cbreak(3,"3 afspraken"), cbreak(4,"4 afspraken"), cbreak (-1,"Nooit")]
  end

  def break_lengths 
    [cbreak (15.minutes,"15 minuten"), cbreak(30.minutes,"30 minuten"), cbreak(45.minutes,"45 minuten"), cbreak (60.minutes,"60 minuten")]
  end


  def cbreak (number, text)
    {text:text, number:number}
  end

  def create_schedule_from_hash(h)     
    current_time = h["starttime"]  
    end_time = h["endtime"]
    break_every = breaks[h["break_frequency"]][:number]
    break_length = break_lengths[h["break_time"]][:number]
    spot_length = 30.minutes

    before_break = break_every

    schedule = []

    while (current_time + spot_length <= end_time)
      if before_break == 0
        current_time = current_time + break_length 
        before_break = break_every
      end
      before_break -=1

      schedule << {:start=>current_time, :end=>current_time+ spot_length}
      current_time = current_time + spot_length
    end

    @spots = schedule
    self
  end
end
