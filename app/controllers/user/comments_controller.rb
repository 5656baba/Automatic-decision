class User::CommentsController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    @comment = current_user.comments.build(comment_params)
    @comment.post_id = post.id
    if @comment.save
      redirect_to post_path(params[:post_id])
    else
      render :"user/posts/show"
    end
  end

  def destroy
    if @comment = Comment.find(params[:id]).destroy
      redirect_to post_path(params[:post_id])
    else
      render template: "user/posts/show"
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:comment).merge(user_id: current_user.id, post_id: params[:post_id])
  end
end
