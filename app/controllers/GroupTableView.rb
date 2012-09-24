class GroupTableView < UITableViewController 
  def initWithNibName(name, bundle: bundle)
    super
    self.tabBarItem = UITabBarItem.alloc.initWithTabBarSystemItem(UITabBarSystemItemFavorites, tag: 1)
    self    
  end
  
  def viewDidLoad
    @groups= [] 
    loadGroups       
    self.title = "Alle groepen"
  end         
  
  def loadGroups              
    p "Loading groups"
    BubbleWrap::HTTP.get("http://www.cmd-leeuwarden.nl/api/groups/list.json") do |response|

      data = BubbleWrap::JSON.parse(response.body.to_str)      

      @groups = data[:results]
      
      view.reloadData  
      p "Loaded data"
      p @groups.size
    end    
  end
  
  def tableView(tableView, numberOfRowsInSection:section)
    @groups.size
  end      
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    group = @groups[indexPath.row]  
    GroupCell.cellForGroup(group, inTableView:tableView)
  end                 
  

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    detailView = self.storyboard.instantiateViewControllerWithIdentifier("groupDetail")
    detailView.group = @groups[indexPath.row]

    self.navigationController.pushViewController(detailView, animated:true)

  end
  
end
  