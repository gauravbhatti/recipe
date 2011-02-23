class Source < ActiveRecord::Base
  belongs_to :user
  has_many :comments, :as => :commentable
  has_many :recipes
  
  validates_presence_of :title
  
  has_attached_file :photo, :styles => { :medium => "235x215#", :small => "160x160#" },
                    :url  => "/assets/sources/:id/:style/:basename.:extension",
                    :path => "#{Rails.root}/public/assets/sources/:id/:style/:basename.:extension"

  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/jpg']
  
  TYPES = ["book", "magazine", "website_blog", "other"]
  
end
