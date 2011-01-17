class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  layout "user"

  def new
    @user = User.new
    render :layout => false
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      @user.deliver_activation_instructions!
      render :update do |page|
        page.replace_html "new_user", "Thanks for signing up!  Your account has been created. Please check your e-mail for your account activation instructions!"
        page.call "Modalbox.resizeToContent"
      end
    else
      render :update do  |page|
        page.replace_html "errors", "#{error_messages_for :user}"
        page.call "Modalbox.resizeToContent"
      end
    end
  end

  def show
    @user = @current_user
    render :layout => "profile"
  end

  def edit
    @user = @current_user
    render :layout => "source"
  end

  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to user_path(@user)
    else
      render :action => :edit, :layout => "profile"
    end
  end
end
