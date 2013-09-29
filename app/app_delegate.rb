class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    # TestFlight.takeOff "3b072839-1fd6-42a0-a07e-5cae81e23d57"

# App::Persistence[:succesfull_login] =false
    # Controleer op automatisch inloggen
    activeUser = User.new
    if activeUser.login_valid?
      automaticLogin activeUser
    else
      showLogin
    end
    
    
    return true
  end
  

  def showSecondScreen
    @allGroups = GroupTableView.alloc.initWithStyle UITableViewStylePlain  
    @group_nav_controller = UINavigationController.alloc.initWithRootViewController(@allGroups)

    @allStudents = StudentsViewController.alloc.initWithStyle UITableViewStylePlain
    @student_nav_controller = UINavigationController.alloc.initWithRootViewController(@allStudents)

    @subscriptionController = SubscriptionController.alloc.initWithStyle UITableViewStylePlain
    @subscription_nav_controller = UINavigationController.alloc.initWithRootViewController(@subscriptionController)

    @settingsController = SettingsViewController.alloc.initWithNibName(nil, bundle:nil)

    @tab_controller = UITabBarController.alloc.initWithNibName(nil, bundle: nil)
    @tab_controller.viewControllers = [@student_nav_controller, @subscription_nav_controller, @settingsController]
    
    @window.rootViewController = @tab_controller        
    @window.makeKeyAndVisible
  end

  def showLogin
    @loginScreen = LoginViewController.alloc.init   
    @loginScreen.after_login = Proc.new {showSecondScreen}
    @window.rootViewController =  @loginScreen
    @window.makeKeyAndVisible
  end

  def facebookLogin    
    showSecondScreen
  end
  
  def automaticLogin(activeUser)
    activeUser.login do |succes|
      if succes
        showSecondScreen        
      else
        showLogin
      end
    end    
  end
  
  def logout
    showLogin
  end


end