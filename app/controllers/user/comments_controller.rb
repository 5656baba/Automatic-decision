class User::CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    @comment.user_id=current_user.id
    @comment.save
    render template: "user/posts/show"
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    render template: "user/posts/show"
  end

  private
  def comment_params
    params.require(:comment).permit(:comment_content, :post_id)
  end
end
