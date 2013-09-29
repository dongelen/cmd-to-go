class Facebook 
  attr_accessor :permission_facebook

  def self.instance
    @@facebook ||= Facebook.new
  end

  def initialize
    @type = ACAccountTypeIdentifierFacebook
    @account_store = ACAccountStore.alloc.init
    @account_type = @account_store.accountTypeWithAccountTypeIdentifier @type
  end

  def connect(&block)
    @account_store.requestAccessToAccountsWithType @account_type, options:options, completion: lambda { |granted, error_ptr|

      @permission_facebook =  granted
      block.call (granted) if block
    }
  end

  def options
    {
      ACFacebookAppIdKey => '477276032326777',
      ACFacebookPermissionsKey => ["user_about_me", "email"],
      ACFacebookAudienceKey => ACFacebookAudienceOnlyMe
    }
  end

 def search(email, &block)
    accounts = @account_store.accountsWithAccountType @account_type
    raise "No accounts" if accounts.empty? 
    account = accounts.first

    reqURL= NSURL.URLWithString("https://graph.facebook.com/search")

    params = {
      "q"=> email,
      "type" => "user"  
    }
    req=SLRequest.requestForServiceType(SLServiceTypeFacebook, requestMethod:SLRequestMethodGET, URL:reqURL, parameters:params)

    req.account = account
    req.performRequestWithHandler lambda { |response_data, url_response, error|
      NSLog "HTTP response status: #{url_response.statusCode}"
      p response_data
      # $s = response_data
      data = BW::JSON.parse (response_data)
      if data["data"].length>0 
        id = data["data"].first["id"] 

        block.call ("http://graph.facebook.com/#{id}/picture?type=large") if block
        p "http://graph.facebook.com/#{id}/picture?large"
      else
        block.call (nil) if block
      end
    }
  end


end
