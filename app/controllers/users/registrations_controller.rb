class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :user_params, only: [:create]

  def new
    super
  end

  def create
    @user = User.new(user_params)
    @user[:email] = "#{@user.username}@yimails.com"
    if @user.save
      system_user =  User.find(1)
      system_user.letters.create(sender: system_user.email, recipient: @user.email, subject: "Welcome", content: '歡迎使用Yimail! 簡單介面、輕鬆編輯，是您電子郵件的最佳選擇')
      redirect_to user_session_path
    else 
      render :new
    end
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # 在signup時，Devise預設只有email (預設的authentication keys) 和 password 可以傳到model裡，新增欄位都要額外設定
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :lastname, :firstname, :backup_email])
  end

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation, :lastname, :firstname, :backup_email)
  end

end
