$:.unshift("/Library/RubyMotion/lib")

require 'motion/project'
require 'bubble-wrap/http'
require 'bundler'

Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'cmd to go'
  app.identifier = "nl.nhl.cmd.cmd-to-go"

  app.provisioning_profile = "/Users/dongelen/Library/MobileDevice/Provisioning Profiles/cmd_to_go.mobileprovision"
  app.codesign_certificate = "Raymond van Dongelen"
  app.pods do
    # pod 'TapkuLibrary'
    pod 'SVProgressHUD', '~>0.7'
    pod 'QuickDialog'
  end
    
  app.frameworks += [ 'Security', 'MessageUI', 'QuartzCore']
  app.frameworks += ['Social', 'Twitter']

  # 


  # app.info_plist['UIRequiredDeviceCapabilities'] = [
  #   {"armv6"=> ""}
  # ]


  # app.ONLY_ACTIVE_ARCH = true
  
  app.testflight.sdk = 'vendor/TestFlightSDK'
  app.testflight.api_token = '233fe437aeb256444cc6be0d58c6513a_NDY2NjUwMjAxMi0wNi0wMSAwODoxMjo0OS4yMTQwMDM'
  app.testflight.team_token = 'd58a413e7021d4186825b4eaf8e8a831_OTU4MTIyMDEyLTA4LTI1IDE2OjMxOjUwLjYwODQxNA'
  app.testflight.distribution_lists = ['Beta list']

end