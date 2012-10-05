class WaitScreen
	def self.startWait
    SVProgressHUD.show    
	end

	def self.stopWait
    SVProgressHUD.dismiss   
	end

end