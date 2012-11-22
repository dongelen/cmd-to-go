class Subscription
  
  def test
    load do
      p "@@@@@@@@@@@@@@@(((((***********************************)))))"
    end
  end
  
  def load(&afterLoad)
    WaitScreen.startWait
    
    @blockToCallAfterLoad = afterLoad
    @subscriptions = Hash.new
    # first of all, get subscription 
    category_ids =["98","99", "100", "101"]
    # category_ids =["101"]
    
    @toLoad = 1        
    category_ids.each do |id|
      get_my_list id
    end
    finishedLoadingElement
  end

  def number_of_days
    @subscriptions.keys.count
  end
  
  def day_name_for(d)
    @subscriptions.keys[d].dag_naam
  end
  
  def subscriptions_for_daynumber(dnumber)
    @subscriptions[@subscriptions.keys[dnumber]]
  end

  # private
    def whenFinishedCallBlock
      p "To load verlaagt naar #{@toLoad}"
      readyLoadingEverything if @toLoad <= 0
    end
    
    def readyLoadingEverything
      # Reorder the hash zo dat de dagen in de juiste volgorde staan
      @subscriptions=Hash[@subscriptions.sort]
      $s = @subscriptions
      @subscriptions.each do |k,apps|
        p "Voor sort"
        p @subscriptions[k]
        @subscriptions[k]= apps.sort_by {|v| v[:subscription]}
        p "Na sort"
        p @subscriptions[k]
        
      end
      WaitScreen.stopWait
      
      @blockToCallAfterLoad.call 
    end
    
    
    def finishedLoadingElement
      @toLoad-= 1
      whenFinishedCallBlock
    end
  
    def startLoadingElement
      @toLoad+=1      
      p "To load verhoogt naar #{@toLoad}"
    end
  
    def add_appointment(subscription,user)
      d = get_start_time_from_subscription(subscription)
    
      
      start_time = get_start_time_from_subscription(subscription)
      start_date = get_start_date_from_subscription(subscription)

      p "Adding app"
      p start_date
      
      @subscriptions[start_date] ||= Array.new
      @subscriptions[start_date] << {:subscription=>start_time, :user=>user}
      
      $s= subscription
      $ss = @subscriptions
    end



    def get_my_list(id)
      startLoadingElement
      BubbleWrap::HTTP.get("http://www.cmd-leeuwarden.nl/api/subscriptions/lists.json?categoryid=#{id}", User.current.to_header) do |response|
        if response.ok?
          data = BubbleWrap::JSON.parse(response.body.to_str)              
          find_my_subscripables data[:results], forUser:User.current.user_id
        elsif response.status_code.to_s =~ /40\d/
          App.alert("Login failed")
        else
          App.alert(response.error_message)
        end
        finishedLoadingElement
      end

    end
  
    def find_my_subscripables(data, forUser:user_id)
      data[:subscribables].each do |s|
        if s[:organizerid] == user_id
          get_subscriptions s[:api_subscriptions_link]
        end
      end    
    end
  
    def get_subscriptions(link)
      startLoadingElement
      BubbleWrap::HTTP.get(link, User.current.to_header) do |response|
        if response.ok?
          data = BubbleWrap::JSON.parse(response.body.to_str)              
          find_current_subscriptions data[:results]
        elsif response.status_code.to_s =~ /40\d/
          App.alert("Login failed")
        else
          App.alert(response.error_message)
        end      
        finishedLoadingElement
        
      end  
    end
  
    def get_start_time_from_subscription (subscription)
      df = NSDateFormatter.alloc.init
      df.setDateFormat "yyyy-MM-dd HH:mm:ss"
      df.dateFromString(subscription[:startdate])    
    end

    def get_start_date_from_subscription (subscription)
      df = NSDateFormatter.alloc.init
      df.setDateFormat "yyyy-MM-dd HH:mm:ss"
      date = df.dateFromString(subscription[:startdate])    
      calendar = NSCalendar.autoupdatingCurrentCalendar
      preservedComponents = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
      calendar.dateFromComponents(calendar.components(preservedComponents, fromDate:date))            
    end

  
    def midnight_today
      date = NSDate.date
      calendar = NSCalendar.autoupdatingCurrentCalendar
      preservedComponents = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
      calendar.dateFromComponents(calendar.components(preservedComponents, fromDate:date))      
    end
  
    def find_current_subscriptions(subscriptions)
      now = midnight_today
      subscriptions.each do |subscription|
        start_date=get_start_time_from_subscription(subscription)

        # p subscription[:subscribers][0][:userid]

        if now < start_date
          p "getting user"
          get_user subscription if subscription[:subscribers].length > 0

          p subscription
        end
      
        $s = subscription
      end
    end
  
    def get_user(subscription)
      startLoadingElement
      id = subscription[:subscribers][0][:userid]
      filled_subscription = NSDictionary.dictionaryWithDictionary(subscription)
      BubbleWrap::HTTP.get("http://www.cmd-leeuwarden.nl/api/users/user.json?userid=#{id}",  User.current.to_header) do |response|
        if response.ok?
          data = BubbleWrap::JSON.parse(response.body.to_str)              
        
          add_appointment subscription, data[:results]
        elsif response.status_code.to_s =~ /40\d/
          App.alert("Login failed")
        else
          App.alert(response.error_message)
        end      
        finishedLoadingElement
      end

    end
   
end
