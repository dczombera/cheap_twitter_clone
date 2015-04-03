class AccountActivationsController < ApplicationController

  def edit
    @user = User.find_by(email: params[:email])
    if @user && !@user.activated? && @user.authenticated?(:activation, params[:id])
      @user.activate
      log_in @user
      flash[:success] = "May the force be with you."
      redirect_to user_path(@user)
    else
      flash[:danger] = "Uuups. Something went wrong. Your activation link is invalid"
      redirect_to root_url
    end

  end
end
