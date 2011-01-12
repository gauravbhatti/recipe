class User < ActiveRecord::Base
  acts_as_authentic
  
  validates_presence_of :state, :country
  
  def self.find_by_login_or_email(login)
    User.find_by_login(login) || User.find_by_email(login)
  end
  
  def activate!
    self.active = true
    save
  end
  
  def deliver_activation_instructions!
    reset_perishable_token!
    UserMailer.activation_instructions(self).deliver
  end

  def deliver_welcome!
    reset_perishable_token!
    UserMailer.welcome(self).deliver
  end
  
  def deliver_password_reset_instructions!  
    reset_perishable_token!  
    UserMailer.password_reset_instructions(self).deliver
  end
  
end
