module PostsHelper

  def getPostWithID(post_id)
  	@post = Post.find_by(id: post_id)
  end

  def getStatusWithID(status_id)
  	@status = Status.find_by(id: status_id)
  end

end
