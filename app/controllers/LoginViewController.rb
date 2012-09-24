class LoginViewController < Formotion::FormController
  attr_accessor :after_login
  
  def init 
    @form = Formotion::Form.new({
      sections: [{
        title: "Login met je cmd account",
        rows: [{
          title: "Inlognaam",
          key: :user,
          placeholder: "stevejobs",
          type: :string,
          auto_correction: :no,
          auto_capitalization: :none
        }, {
          title: "Password",
          key: :password,
          placeholder: "required",
          type: :string,
          secure: true
        }]
      }, {
        rows: [{
          title: "Login",
          type: :submit,
        }]
      }]
    })

    @form.on_submit do
      @u = User.new
      @u.username=@form.render[:user]
      @u.password=@form.render[:password]

      @u.login do |succes|
        if succes
          if (after_login)
            after_login.call
          end
          
        else
          App.alert("Naam/wachtwoord combinatie is niet geldig")
        end
        
      end
    end    
    super.initWithForm(@form)
  end

  
end