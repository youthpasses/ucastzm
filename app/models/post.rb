class Post < ActiveRecord::Base
  belongs_to :user
  validates :content, length: { maximum: 1000 }
end
