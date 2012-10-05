class User
  attr_accessor :username, :password, :succesfull_login, :user_id

  def initialize
    self.username= App::Persistence[:username]
    self.password= App::Persistence[:password]
    self.succesfull_login = App::Persistence[:succesfull_login]
    self
  end
  
  def login_valid?
    self.succesfull_login
  end
  
  def logout
    self.username= nil
    self.password= nil
    self.succesfull_login = false
    save
  end
  
  def save
    App::Persistence[:username] = self.username
    App::Persistence[:password] = self.password

    App::Persistence[:succesfull_login] = self.succesfull_login
  end
  
  
  def login(&block)
    @after_login=block

    WaitScreen.startWait
    BubbleWrap::HTTP.get("http://www.cmd-leeuwarden.nl/api/users/authenticate.json", to_header) do |response|
      WaitScreen.stopWait
      if response.ok?
        data = BubbleWrap::JSON.parse(response.body.to_str)      
        self.succesfull_login = data[:results] == false ? false : true
        self.save
        p data[:results]
        self.user_id = data[:results][:userid]
        @@logged_in = self
                
        @after_login.call(self.succesfull_login)
      elsif response.status_code.to_s =~ /40\d/
        App.alert("Login failed")
      else
        App.alert(response.error_message)
      end
    end    
    
  end
  
  def self.current
    @@logged_in
  end
  
  def to_header    
     base64= ["#{self.username}:#{self.password}"].pack("m0")     
     {:headers=>{"Authorization" => "Basic #{base64}"}}
  end  

end
