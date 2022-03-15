class User::LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :comment_params

  def create
    like = current_user.likes.new(comment_id: @comment.id)
    like.save
  end

  def destroy
    @like = Like.find_by(user_id: current_user.id, comment_id: @comment.id).destroy
  end

  private
  def comment_params
    @comment = Comment.find(params[:comment_id])
  end
end
