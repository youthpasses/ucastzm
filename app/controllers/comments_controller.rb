class CommentsController < ApplicationController
  def new
  end
  def create
  	#redirect_to index_path
  	post_id = params[:comment][:post_id]
  	@comment = Comment.new(comment_params)
  	@comment.save
  	@posts = Post.where(id: post_id.to_i)
  	redirect_to @posts[0]
  end



  def delComment
    if params[:comment_id]
      Comment.find_by_sql('delete from Comments where id = ' + params[:comment_id].to_s)
    end
    @posts = Post.where(id: params[:post_id].to_i)
    redirect_to @posts[0]
  end

  def comment_params
    params.require(:comment).permit(:post_id, :form_user_id, :to_user_id, :content)
  end
end
