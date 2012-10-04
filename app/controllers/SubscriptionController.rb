class SubscriptionController < UITableViewController 

  def initWithNibName(name, bundle: bundle)
    @subscription = Subscription.new
    
    tabBarItem = self.tabBarItem
    tabBarItem.image = UIImage.imageNamed "83-calendar"
    tabBarItem.title = "Afspraken"
    self
  end
  
  def viewDidAppear(animated)
    @refreshHeaderView ||= begin
      rhv = RefreshTableHeaderView.alloc.initWithFrame(CGRectMake(0, 0 - self.tableView.bounds.size.height, self.tableView.bounds.size.width, self.tableView.bounds.size.height))
      rhv.delegate = self
      rhv.refreshLastUpdatedDate    
      tableView.addSubview(rhv)
      
      $t = self
      rhv
    end 
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
    @sections[section] ? @sections[section].size : 0
  end      

  def tableView(tableView, numberOfRowsInSection:section)  
    dn = @subscription.day_name_for section
     @subscription.subscriptions_for_dayname(dn).count
  end      

  def refresh
    p "Refresh"
    @loading = true

    @subscription.load do
      @last_load = Time.now
      self.tableView.reloadData
      @loading = false
      @refreshHeaderView.refreshScrollViewDataSourceDidFinishLoading(self.tableView)      
    end

  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    dn = @subscription.day_name_for indexPath.section    
    day_subscriptions = @subscription.subscriptions_for_dayname(dn)
    subscription= day_subscriptions[indexPath.row]
    
    SubscriptionCell.cellForSubscription(subscription, inTableView:tableView)
  end      
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    dn = @subscription.day_name_for indexPath.section    
    day_subscriptions = @subscription.subscriptions_for_dayname(dn)
    subscription= day_subscriptions[indexPath.row]
    p subscription[:user]
    studentView = StudentViewController.alloc.init
    
    self.navigationController.pushViewController(studentView, animated:true)
    studentView.student=subscription[:user]
    
  end  
             
  
  # Delegate voor tableview pull to refresh

  def scrollViewDidScroll(scrollView)
    @refreshHeaderView.refreshScrollViewDidScroll(scrollView)
  end
  
  def scrollViewDidEndDragging(scrollView, willDecelerate:decelerate)
    @refreshHeaderView.refreshScrollViewDidEndDragging(scrollView)
  end

  
  def refreshTableHeaderDataSourceLastUpdated(sender)
    @last_load
  end        
  
  def refreshTableHeaderDataSourceIsLoading(sender)
    p "called 2"
    @loading
  end
  
  def refreshTableHeaderDidTriggerRefresh (sender)
    p "Called"
    refresh
  end
  
end