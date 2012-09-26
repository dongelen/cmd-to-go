class Subscription
  
  def test
    load do
      p "@@@@@@@@@@@@@@@(((((***********************************)))))"
    end
  end
  
  def load(&afterLoad)
    @blockToCallAfterLoad = afterLoad
    @subscriptions = Hash.new
    # first of all, get subscription 
    # category_ids =["99", "100,"101"]
    category_ids =["101"]
    
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
    @subscriptions.keys[d].to_s
  end
  
  def subscriptions_for_dayname(dname)
    @subscriptions[dname]
  end


  # private
    def whenFinishedCallBlock
      p "To load verlaagt naar #{@toLoad}"
      @blockToCallAfterLoad.call if @toLoad <= 0
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
      d = get_start_date_from_subscription(subscription)
    
      @subscriptions[d.dag_naam] ||= Array.new
      p "Adding app"
      p subscription
      
      start_date = get_start_date_from_subscription(subscription)
      p start_date
      @subscriptions[d.dag_naam] << {:subscripton=>start_date, :user=>user}
      
      
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
  
    def get_start_date_from_subscription (subscription)
      df = NSDateFormatter.alloc.init
      df.setDateFormat "yyyy-MM-dd HH:mm:ss"
      df.dateFromString(subscription[:startdate])
    
    end
  
    def find_current_subscriptions(subscriptions)
      now = Time.now
      subscriptions.each do |subscription|
        # df = NSDateFormatter.alloc.init
        # df.setDateFormat "yyyy-MM-dd HH:mm:ss"
        # start_date= df.dateFromString(subscription[:startdate])
        # 
        start_date=get_start_date_from_subscription(subscription)

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
          p subscription
          p data[:results][:displayname]
        
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
