class PickDateViewController < UIViewController
  def viewDidLoad
    @calendar =  TKCalendarMonthView.alloc.init
    @calendar.delegate = self
    self.view.addSubview(@calendar)    
  end

  def calendarMonthView(monthView, didSelectDate:date)
    return if self.navigationController.topViewController == @spotViewController
    @spotViewController ||= CreateSpotsViewController.create_dialog

    @spotViewController.date = date
    self.navigationController.pushViewController(@spotViewController, animated:true) 


    # data = {subscribableid: 1449, start: "2013-04-06 09:00", end: "2013-04-06 12:00"}
    # BW::HTTP.get("http://www.cmd-leeuwarden.nl/api/subscriptions/addtimes.json?subscribableid=1449&start=2013-04-06 09:00&end=2013-04-06 12:00") do |response|
    #   d = BubbleWrap::JSON.parse(response.body.to_str)      
    #   p d
    # end 

    p "Date selected #{date}"
  end

end