class Post < ActiveRecord::Base
  def Post.tag_idcollection
  	tag_id_collection = Array.new
  	i = 0
  	Post.select(:tag_id).distinct.each do |post|
  		tag_id_collection[i] = post.tag_id
  		i += 1
  	end
  	return tag_id_collection.sort
  end

  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :content, length: { maximum: 1000 }

end
