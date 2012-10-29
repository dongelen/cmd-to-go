class SubscriptionController < UITableViewController 

  def initWithNibName(name, bundle: bundle)
    @subscription = Subscription.new
    
    tabBarItem = self.tabBarItem
    tabBarItem.image = UIImage.imageNamed "83-calendar"
    tabBarItem.title = "Afspraken"
    self
  end
  
  def viewDidAppear(animated)
    # @refreshHeaderView ||= begin
    #   rhv = RefreshTableHeaderView.alloc.initWithFrame(CGRectMake(0, 0 - self.tableView.bounds.size.height, self.tableView.bounds.size.width, self.tableView.bounds.size.height))
    #   rhv.delegate = self
    #   rhv.refreshLastUpdatedDate    
    #   tableView.addSubview(rhv)
    #   
    #   $t = self
    #   rhv
    # end 
    # 
    @refreshControl = UIRefreshControl.alloc.init
    @refreshControl.addTarget self, action:'refresh', forControlEvents:UIControlEventValueChanged
    self.refreshControl = @refreshControl
  end  

  
  
  def viewDidLoad
    self.title = "Afspraken"
    refresh
  end 
  
  def numberOfSectionsInTableView(tableView)
    @subscription.number_of_days
  end
  
  def tableView(tableView, titleForHeaderInSection:section)
    @subscription.day_name_for section
  end
  

  def tableView(tableView, numberOfRowsInSection:section)  
    p "Gettint section #{section}"
    @subscription.subscriptions_for_daynumber(section).count
  end      

  def refresh
    @loading = true

    @subscription.load do
      @last_load = Time.now
      self.tableView.reloadData
      @loading = false
      @refreshControl.endRefreshing
    end

  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    day_subscriptions = @subscription.subscriptions_for_daynumber(indexPath.section)
    subscription= day_subscriptions[indexPath.row]
    
    SubscriptionCell.cellForSubscription(subscription, inTableView:tableView)
  end      
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)    
    day_subscriptions = @subscription.subscriptions_for_daynumber(indexPath.section)
    subscription= day_subscriptions[indexPath.row]
    p subscription[:user]
    studentView = StudentViewController.alloc.init
    
    self.navigationController.pushViewController(studentView, animated:true)
    studentView.student=subscription[:user]    
  end  
             
  
end