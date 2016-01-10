#encoding:utf-8
class LikesController < ApplicationController

  def dellike
    if params[:post_id]
      Like.find_by_sql('delete from Likes where post_id = ' + params[:post_id].to_s + ' and user_id = ' + current_user.id.to_s)
      redirect_to current_user
    end
  end

end
