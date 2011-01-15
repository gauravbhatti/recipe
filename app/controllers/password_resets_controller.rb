class PasswordResetsController < ApplicationController

  before_filter :load_user_using_perishable_token, :only => [:edit, :update]
  layout "user"

  def new
    render :layout => false
  end

  def create  
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_password_reset_instructions!
      render :update do |page|
        page.replace_html "forgot_form", "Instructions to reset your password have been emailed to you. " + "Please check your email."
        page.call "Modalbox.resizeToContent"
      end  
    else
      render :update do |page|
        page.replace_html "notice", "No user was found with that email address"
        page.call "Modalbox.resizeToContent"
      end
    end
  end

  def edit
    render
  end

  def update  
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save_without_session_maintenance
      flash[:notice] = "Your password was successfully updated"
      redirect_to new_user_session_path
    else
      render :action => :edit
    end
  end  

  private

  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:notice] = "We're sorry, but we could not locate your account. " +  
      "If you are having issues try copying and pasting the URL " +  
      "from your email into your browser or restarting the " +  
      "reset password process."
      redirect_to new_user_session_path
    end
  end
end
