class Source < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :title
  
  TYPES = ["book", "magazine", "website/blog", "other"]
  
end
