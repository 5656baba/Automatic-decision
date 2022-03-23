class User::CommentsController < ApplicationController
  before_action :authenticate_user!
  def create
    post = Post.find(params[:post_id])
    @comment = current_user.comments.build(comment_params)
    @comment.post_id = post.id
    if @comment.save
      redirect_to post_path(params[:post_id])
      flash[:notice] = "コメントの投稿に成功しました。"
    else
      flash[:notice] = "コメント内容を入力してください。"
      redirect_to post_path(params[:post_id])
    end
  end

  def destroy
    if @comment = Comment.find(params[:id]).destroy
      redirect_to post_path(params[:post_id])
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:comment).merge(user_id: current_user.id, post_id: params[:post_id])
  end
end
