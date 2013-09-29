class ScheduleViewController < UITableViewController
  def numberOfSectionsInTableView(tableView)
    1
  end
    
  def schedule=(s)
    @schedule=s
    self.tableView.reloadData
  end


  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier("cell1")
        
    if (!cell)
      cell= UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:"cell1")
    end
    # cell.textLabel.text = @schedule.spots[indexPath.row]
    p @schedule.spots[indexPath.row][:start]
    cell.textLabel.text = make_time @schedule.spots[indexPath.row][:start]

    cell
  end        

  def make_time(t)
    "#{t.hour}:#{t.min}"
  end

  def tableView(tableView, numberOfRowsInSection:section)  
    @schedule.spots.size
  end      

end