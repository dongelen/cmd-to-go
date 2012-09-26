class SubscriptionCell < UITableViewCell
  CellID = 'STBlaCellIdentifier'
  MessageFontSize = 14

  def self.cellForSubscription(subscription, inTableView:tableView)
    cell = tableView.dequeueReusableCellWithIdentifier(GroupCell::CellID) || SubscriptionCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CellID)
    cell.fillWithSubscription(subscription, inTableView:tableView)
    cell
  end
 
  def initWithStyle(style, reuseIdentifier:cellid)
    if super
      self.textLabel.numberOfLines = 0
      self.textLabel.font = UIFont.systemFontOfSize(MessageFontSize)
    end
    self
  end
 
  def fillWithSubscription(subscription, inTableView:tableView)
    time=subscription[:subscripton]
    p time 
    student = subscription[:user]
    # self.detailTextLabel.text = time.to_s if time
    
    self.textLabel.text= "#{time.hour.to_s}:#{time.min.to_s} "  + makeName(student)
    # self.textLabel.text = makeName(student)
    # group[:name]    
  end

  
  def makeName(student)
    student[:firstname] +  (student[:infix].size>0 ? " " + student[:infix]: "") + " " + student[:lastname]
  end


  # def layoutSubviews
  #   super
  #   self.imageView.frame = CGRectMake(2, 2, 49, 49)
  #   label_size = self.frame.size
  #   self.textLabel.frame = CGRectMake(57, 0, label_size.width - 59, label_size.height)
  # end
end
