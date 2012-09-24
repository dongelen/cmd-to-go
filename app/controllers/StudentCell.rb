class StudentCell < UITableViewCell
  CellID = 'STCellIdentifier'
  MessageFontSize = 14

  def self.cellForStudent(student, inTableView:tableView)
    cell = tableView.dequeueReusableCellWithIdentifier(GroupCell::CellID) || StudentCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CellID)
    cell.fillWithStudent(student, inTableView:tableView)
    cell
  end
 
  def initWithStyle(style, reuseIdentifier:cellid)
    if super
      self.textLabel.numberOfLines = 0
      self.textLabel.font = UIFont.systemFontOfSize(MessageFontSize)
    end
    self
  end
 
  def fillWithStudent(student, inTableView:tableView)
    self.textLabel.text = makeName(student)
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
