class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    if params.has_key?(:password_reset) && params[:password_reset].has_key?(:email)
      @user = User.find_by(email: params[:password_reset][:email].downcase)
      if @user
        @user.create_reset_digest
        @user.send_password_reset_email
        flash[:info] = "Happens to every guy sometimes this does. Email sent with password reset instructions."
        redirect_to root_url
      else
        flash[:danger] = "Email address not found my lost padawan."
        render 'new'
      end
    end
  end

  def edit
  end

  def update
    if password_blank?
      flash.now[:danger] = "Password can't be blank young padawan."
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = "Powerful you have become, the dark side I sense in you. Password has been set."
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.required(:user).permit(:password, :password_confirmation)
    end

    # Returns true of password field is blank
    def password_blank?
      unless params.has_key?(:user) && params[:user].has_key?(:password)
        redirect_to root_url
      end
      params[:user][:password].blank?
    end

    # Before filters

    def get_user
      unless params.has_key?(:email)
        redirect_to root_url
      end
      @user = User.find_by(email: params[:email])
    end

    # Confirms a valid user
    def valid_user
      unless params.has_key?(:id)
        redirect_to root_url
      end
      unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    # Checks expiration of reset token
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "This force is not anymore with you young padawan. Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
end
