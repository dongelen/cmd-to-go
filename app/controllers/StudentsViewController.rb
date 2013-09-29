class StudentsViewController < UITableViewController 
  def initWithNibName(name, bundle: bundle)
    super
    tabBarItem = self.tabBarItem
    tabBarItem.image = UIImage.imageNamed "112-group"
    tabBarItem.title = "Studenten"
    self    
  end
  
  def viewDidLoad
    @sections = [[],[],[]]
    loadStudents       
    self.title = "Studenten"

    @refreshControl = UIRefreshControl.alloc.init
    @refreshControl.addTarget self, action:'refresh', forControlEvents:UIControlEventValueChanged
    self.refreshControl = @refreshControl    
  end         
  
  def refresh
    loadStudents
  end

  def viewWillAppear(animated)
    @facebook = Facebook.instance
    @facebook.connect do|success|
      p "User facebook login #{success}"
    end

  end

  def ready_loading
    @number_loaded+=1

    if @number_loaded == 4
      @refreshControl.endRefreshing      
    end
    view.reloadData  
  end


  def loadStudents              
    #Afstudeerders (als vakdocent)
    @number_loaded=0
    BubbleWrap::HTTP.get("http://www.cmd-leeuwarden.nl/api/userlists/users.json?category=Afstudeerders (als vakdocent)") do |response|
      d1 = BubbleWrap::JSON.parse(response.body.to_str)      
      @sections[0] = d1[:results]      
      
      ready_loading
    end 

    BubbleWrap::HTTP.get("http://www.cmd-leeuwarden.nl/api/userlists/users.json?category=Afstuderen (als mentor)") do |response|
      d2 = BubbleWrap::JSON.parse(response.body.to_str)      
      @sections[1] = d2[:results]      
      ready_loading
    end 
    
    BubbleWrap::HTTP.get("http://www.cmd-leeuwarden.nl/api/userlists/users.json?category=Mentorstudenten") do |response|
      d3 = BubbleWrap::JSON.parse(response.body.to_str)      
      @sections[2] = d3[:results]      
      ready_loading
    end
    
    # Stagiairs
    BubbleWrap::HTTP.get("http://www.cmd-leeuwarden.nl/api/userlists/users.json?category=Stagiairs") do |response|
      d4 = BubbleWrap::JSON.parse(response.body.to_str)      
      @sections[3] = d4[:results]      
      ready_loading
    end

  end

  def numberOfSectionsInTableView(tableView)
    4
  end
  
  def tableView(tableView, titleForHeaderInSection:section)
    ["Afstuderen vakdocent",  "Afstudeermentor", "Mentor", "Stagairs"][section]
  end
  
  def tableView(tableView, numberOfRowsInSection:section)
    @sections[section] ? @sections[section].size : 0
  end      
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    student = @sections[indexPath.section][indexPath.row]  
    StudentCell.cellForStudent(student, inTableView:tableView)
  end                 
  

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    studentView = StudentViewController.alloc.init(@sections[indexPath.section][indexPath.row])

    self.navigationController.pushViewController(studentView, animated:true)
    # studentView.student=@sections[indexPath.section][indexPath.row]
    
  end
  
end
