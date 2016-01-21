module PostsHelper

  def getPostWithID(post_id)
  	@post = Post.find_by(id: post_id)
  end

  def getStatusWithID(status_id)
  	@status = Status.find_by(id: status_id)
  end

  def getPostsCountWithUserID_juanzeng(user_id)
  	@posts = Post.find_by_sql('select * from Posts where status_id = "3" and user_id = ' + user_id.to_s)
  end

end
