class Recipe < ActiveRecord::Base
  
  belongs_to :source
  belongs_to :user
  has_many :comments, :as => :commentable
  
  validates_presence_of :title
  
  has_attached_file :image, :styles => { :medium => "235x215#", :small => "160x160#" },
                    :url  => "/assets/sources/:id/:style/:basename.:extension",
                    :path => "#{Rails.root}/public/assets/sources/:id/:style/:basename.:extension"

  validates_attachment_size :image, :less_than => 5.megabytes
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png', 'image/jpg']
  
end
