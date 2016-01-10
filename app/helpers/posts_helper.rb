module PostsHelper

  def getPostWithID(post_id)
  	@post = Post.find_by(id: post_id)
  end

end
