class CreateSpotsViewController < RMDialogController
  attr_accessor :date

  def loadView
    super
    @saveButton = UIBarButtonItem.alloc.initWithTitle "Bewaar", style:UIBarButtonItemStylePlain, target:self, action:"saveSpots"
    
    self.navigationItem.rightBarButtonItem = @saveButton
  end
  
  def viewDidLoad
    super
    self.view.backgroundColor = UIColor.whiteColor
  end
  
  def self.create_dialog    
    root = RMDialog.create(title:"Nieuwe momenten", grouped:true) do
      
      section(name: "Nieuwe serie") do 
        entry title:"Naam", placeholder:"Optioneel, voor terugvinden"


        time title:"Van", date: 9.oclock, key:"starttime", mode: UIDatePickerModeTime
        time title:"Tot", date: 12.oclock, key:"endtime", mode: UIDatePickerModeTime

        button(title:"Bekijk planning", key:"plan").controllerAction="onPlan"
      end      


      section(name:"Pauze ") do
        dates = ["2 afspraken", "3 afspraken", "4 afspraken", "Nooit"]
        radio({items: dates, selected:0, title:"Na elke" }).key="break_frequency"
        
        minutes = ["15 minuten", "30 minuten", "45 minuten", "60 minuten"]
        radio({items: minutes, selected:0, title:"Duur"}).key="break_time"
      end

    end
    root.controllerName = "CreateSpotsViewController"    

    controller = CreateSpotsViewController.controllerForRoot(root)
  end  

  def onPlan
    @schedule_view ||= ScheduleViewController.alloc.initWithNibName(nil, bundle:nil)
    schedule = Schedule.new
    options = {}
    root.fetchValueIntoObject options

    @schedule_view.schedule = schedule.create_schedule_from_hash options

    self.navigationController.pushViewController(@schedule_view, animated:true)

  end

  def saveSpots
  end

end
