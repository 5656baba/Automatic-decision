class User::ResumesController < ApplicationController
  def index
    @post_recipes=PostRecipe.all
    @post_recipes.user_id=current_user.id
  end

  def show
    @posts=Post.all
    @posts.user_id=current_user.id
  end

  def edit
    @comments=Comment.all
    @comments.user_id=current_user.id
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    render :index
  end
end
