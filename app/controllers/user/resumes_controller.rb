class User::ResumesController < ApplicationController
  before_action :authenticate_user!
  def show
    @posts = current_user.posts.page(params[:page]).per(10)
  end

  def edit
    @comments = current_user.comments.page(params[:page]).per(10)
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.user_id = current_user.id
    @comment.destroy
    redirect_to edit_resume_path(current_user.id)
  end
end
