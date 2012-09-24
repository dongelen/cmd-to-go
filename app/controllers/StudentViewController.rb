class StudentViewController < UIViewController
  def viewDidLoad
    self.title = "Bla"
    
    self.view.setBackgroundColor UIColor.whiteColor
    @name = UITextField.alloc.initWithFrame ([[110,10],[180,20]])  
    @name.textColor=UIColor.blackColor
    @name.label = "Bla"


    @email = UITextField.alloc.initWithFrame ([[110,40],[180,20]])  
    @email.textColor=UIColor.blackColor
    @email.label = "Bla"    

    @mobile = UITextField.alloc.initWithFrame ([[110,70],[180,20]])  
    @mobile.textColor=UIColor.blackColor
    @mobile.label = "Bla"    
    
    @image = UIImageView.alloc.initWithFrame([[10,10], [100,100]]) 
    layer = @image.layer
    layer.setMasksToBounds true 
    layer.setCornerRadius 10.0
    layer.setBorderColor UIColor.blackColor.CGColor
    layer.setBorderWidth 1.0;

    
    addMessageButtons
    @call = UIButton.buttonWithType UIButtonTypeRoundedRect
    @call.frame= [[10,140],[280,50]]
    @call.setTitle "Bel", forState:UIControlStateNormal
    @call.when(UIControlEventTouchUpInside) do
      phoneNumber = NSURL.alloc.initWithString "tel:"+ @phonenumber
      UIApplication.sharedApplication.openURL phoneNumber
    end    

    
    self.view.addSubview @name
    self.view.addSubview @email
    self.view.addSubview @image
    self.view.addSubview @call
    self.view.addSubview @mobile
  end
  
  def addMessageButtons
    
    unless MFMessageComposeViewController.canSendText 
      return
    end
    
    @message = UIButton.buttonWithType UIButtonTypeRoundedRect
    @message.frame= [[10,200],[280,50]]
    @message.setTitle "Waar ben je?", forState:UIControlStateNormal
    @message.when(UIControlEventTouchUpInside) do
      sendMessage "Volgens mijn agenda hebben we op dit moment een afspraak. Waar ben je?"
    end    

    @message1 = UIButton.buttonWithType UIButtonTypeRoundedRect
    @message1.frame= [[10,260],[280,50]]
    @message1.setTitle "Afspraak", forState:UIControlStateNormal
    @message1.when(UIControlEventTouchUpInside) do
      sendMessage "We hebben elkaar al een tijdje niet gesproken, kun je een afspraak met me maken op de cmd website?"
    end    

    
    self.view.addSubview @message
    self.view.addSubview @message1


  end


  def sendMessage(message)
    controller = MFMessageComposeViewController.alloc.init
    controller.messageComposeDelegate = self
    controller.body= message
    controller.recipients=[@phonenumber]
    self.presentModalViewController(controller, animated:true)  
  end

  
  
  def sendEmail
    controller = MFMailComposeViewController.alloc.init
    controller.mailComposeDelegate = self
    controller.setSubject("My Subject")
    controller.setMessageBody("Hello there", isHTML:false)
    self.presentModalViewController(controller, animated:true)  
  end
  

  
  def mailComposeController(controller, didFinishWithResult:result, error:error)
    if result == MFMailComposeResultSent
      puts "It's away!"
    end
    self.dismissModalViewControllerAnimated(true)
  end  
  
  
  
  def messageComposeViewController (controller, didFinishWithResult:result)
    self.dismissModalViewControllerAnimated(true)    
  end

  def student=(s)
    loadImage(s[:avatar_link])
    @name.label = makeName(s)
    @email.label = s[:email]
    loadPhonenumber(s)
    p s
    # p = AddressBook::Person.find_by_last_name(s[:lastname])
    # @telnumber.label = p[:first_name] if p

  end
  
  def loadPhonenumber(student)
    BubbleWrap::HTTP.get(student[:web_link]) do |response|  
      parser = Hpple.HTML(response.body.to_str)
      allStuff = parser.xpath("//div[@class='userinfo']//div[@class='general_info_value']")
      p $allStuff
      parser.xpath("//div[@class='userinfo']//div[@class='general_info_value']").each do |value|
        v_str = value.to_s
        p v_str
        @phonenumber = v_str if (v_str=~ /06/)== 0
      end
      @mobile.label = @phonenumber
      # student[:phonenumber] = phonenumber
    end
    
  end
  
  
  
  def loadImage(newImageURL) 
    @imageURL = newImageURL
    Dispatch::Queue.concurrent.async do
      image_data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString(newImageURL))
      if image_data         
        @imageImage = UIImage.alloc.initWithData(image_data)
        Dispatch::Queue.main.sync do
          @image.image = @imageImage
        end
      end
    end

  end

  def makeName(student)
    student[:firstname] +  (student[:infix].size>0 ? " " + student[:infix]: "") + " " + student[:lastname]
  end

    
end