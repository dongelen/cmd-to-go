

class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)


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

    # @tab_controller = UITabBarController.alloc.initWithNibName(nil, bundle: nil)
    # @tab_controller.viewControllers = [@student_nav_controller, @group_nav_controller]
    
    # @window.rootViewController = @tab_controller        
    @window.rootViewController = @student_nav_controller
    @window.makeKeyAndVisible
  end

  def showLogin
    @loginScreen = LoginViewController.alloc.init   
    @loginScreen.after_login = Proc.new {showSecondScreen}
    @window.rootViewController =  @loginScreen
    @window.makeKeyAndVisible
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


end