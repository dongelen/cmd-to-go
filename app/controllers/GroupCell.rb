class GroupCell < UITableViewCell
  CellID = 'CellIdentifier'
  MessageFontSize = 14

  def self.cellForGroup(group, inTableView:tableView)
    cell = tableView.dequeueReusableCellWithIdentifier(GroupCell::CellID) || GroupCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CellID)
    cell.fillWithGroup(group, inTableView:tableView)
    cell
  end
 
  def initWithStyle(style, reuseIdentifier:cellid)
    if super
      self.textLabel.numberOfLines = 0
      self.textLabel.font = UIFont.systemFontOfSize(MessageFontSize)
    end
    self
  end
 
  def fillWithGroup(group, inTableView:tableView)
    self.textLabel.text = group[:name]    
  end


  # def layoutSubviews
  #   super
  #   self.imageView.frame = CGRectMake(2, 2, 49, 49)
  #   label_size = self.frame.size
  #   self.textLabel.frame = CGRectMake(57, 0, label_size.width - 59, label_size.height)
  # end
end
