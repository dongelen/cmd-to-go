class Fixnum 
  def oclock
    date = NSDate.date
    gregorian = NSCalendar.alloc.initWithCalendarIdentifier(NSGregorianCalendar)
    components = gregorian.components(NSUIntegerMax, fromDate: date)
    components.setHour self
    components.setMinute 0
    components.setSecond 0
    gregorian.dateFromComponents components
  end

  def hours
    self * 3600
  end
  def hour
    hours
  end

  def seconds
    self
  end

  def second
    seconds
  end

  def minute
    minutes
  end
  def minutes
    self * 60
  end

  def day
    days
  end

  def days
    24*3600 * self
  end

end