class User < ActiveRecord::Base
  acts_as_authentic
  ajaxful_rater
  
  validates_presence_of :name, :state, :country
  
  has_attached_file :avatar, :styles => { :medium => "200x118!", :small => "160x160#", :minor => "80x80#" },
                    :url  => "/assets/users/:id/:style/:basename.:extension",
                    :path => "#{Rails.root}/public/assets/users/:id/:style/:basename.:extension"

  validates_attachment_size :avatar, :less_than => 5.megabytes
  validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/png', 'image/jpg']
  
  has_many :sources
  has_many :comments
  has_many :recipes
  
  def self.find_by_login_or_email(login)
    User.find_by_login(login) || User.find_by_email(login)
  end
  
  def activate!
    self.active = true
    save
  end
  
  def sex
    self.gender == true ? "Male" : "Female"
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
