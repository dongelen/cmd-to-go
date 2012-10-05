class SettingsViewController 
  def initWithNibName(name, bundle: bundle)        
    screen = create_dialog

    tabBarItem = screen.tabBarItem
    tabBarItem.image = UIImage.imageNamed "19-gear"
    tabBarItem.title = "Instellingen"
    screen
  end
  
  def viewDidLoad
    super
    self.view.backgroundColor = UIColor.whiteColor
    self.create_dialog
  end
  
  def create_dialog    
    root = RMDialog.create(title:"Instellingen", grouped:true) do
      url = "http://www.apple.com"
      
      # First Section with Name
      section(name: "Je gegevens") do        
        label title:"Ingelogd als", value:User.current.username
        button title:"Log uit" do
          User.current.logout
          App.shared.delegate.logout
        end
      
      end
      

    end
    
    # root.bindToObject({"empty" => [], "something" => ["first", "second"]})
    
    navigation = RMDialogController.controllerWithNavigationForRoot(root)
  end     
end