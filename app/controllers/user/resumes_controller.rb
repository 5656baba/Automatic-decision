class User::ResumesController < ApplicationController
  def show
    @posts=current_user.posts
  end

  def edit
    @comments=current_user.comments
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.user_id = current_user.id
    @comment.destroy
    redirect_to edit_resume_path(current_user.id)
  end
end
