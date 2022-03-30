class User::LikesController < ApplicationController
  before_action :authenticate_user!
  # before_action :comment_params

  def create
    @comment = Comment.find(params[:comment_id])
    like = @comment.likes.new(user_id: current_user.id, post_id: @comment.post.id)
    like.save!
    @post = Post.find(params[:post_id])
  end                           # find idのみ  find_by カラム指定

  def destroy
    @comment = Comment.find_by(id: params[:comment_id], post_id: params[:post_id])
    like = current_user.likes.find_by(comment_id: @comment.id, post_id: @comment.post.id)
    like.destroy
    @post = Post.find(params[:post_id])
  end

  private

  def comment_params
    @comment = Comment.find(params[id :comment_id, :post_id, :user_id])
  end
end
