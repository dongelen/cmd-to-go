describe 'schedule' do

  it "creates 2 appointments in an hour" do
    options = {"starttime" => Time.now, "endtime"=>Time.now + 1.hour, "break_frequency"=>0, "break_time"=>0}
    schedule = Schedule.new.create_schedule_from_hash options
    schedule.spots.size.should == 2

    schedule.spots[0][:start].hour.should == Time.now.hour
  end

  it "creates breaks" do
    options = {"starttime" => Time.now, "endtime"=>Time.now + 2.hours, "break_frequency"=>0, "break_time"=>0}
    # after 1 hour 15 min break, 9-9.30, 9.30 - 10.00, 10.00 break, 10.15 -10.45, 10.45 nothing
    schedule = Schedule.new.create_schedule_from_hash options
    schedule.spots.size.should == 3
  end

  it "creates breaks in morning" do
    options = {"starttime" => Time.now, "endtime"=>Time.now + 3.hours, "break_frequency"=>0, "break_time"=>0}
    # after 1 hour 15 min break, 9-9.30, 9.30 - 10.00, 10.00 break, 
    # 10.15 -10.45, 10.45-11.15, 11.15 break, 11.30 -12.00 
    schedule = Schedule.new.create_schedule_from_hash options
    schedule.spots.size.should == 5
  end

  it "creates longer breaks" do
    options = {"starttime" => Time.now, "endtime"=>Time.now + 4.hours, "break_frequency"=>2, "break_time"=>2}
    # after 1 hour 15 min break, 
    # 9-9.30, 9.30 - 10.00, 10.00-10.30, 10.30-11.00, 11.00 - 11.45 break 
    # 11.45 - 12.15, 12.15 - 12.45
    schedule = Schedule.new.create_schedule_from_hash options
    schedule.spots.size.should == 6
  end

  it "doesnt create breaks with right setting" do
    options = {"starttime" => Time.now, "endtime"=>Time.now + 4.hours, "break_frequency"=>3, "break_time"=>2}
    schedule = Schedule.new.create_schedule_from_hash options
    schedule.spots.size.should == 8
  end

  it "" do
    options = {"starttime" => Time.now, "endtime"=>Time.now + 3.hours, "break_frequency"=>1, "break_time"=>1}
    schedule = Schedule.new.create_schedule_from_hash options
    schedule.spots.size.should == 5
  end


end
