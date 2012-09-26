class SubscriptionController < UITableViewController 

  def initWithNibName(name, bundle: bundle)
    @subscription = Subscription.new
    self
  end
  
  def viewDidLoad
    self.title = "Afspraken"
    @subscription.load do
      self.tableView.reloadData
    end
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

  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    dn = @subscription.day_name_for indexPath.section    
    day_subscriptions = @subscription.subscriptions_for_dayname(dn)
    subscription= day_subscriptions[indexPath.row]
    
    SubscriptionCell.cellForSubscription(subscription, inTableView:tableView)
  end                 
          
  
end