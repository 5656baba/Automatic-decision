class User::PostsController < ApplicationController
  def index
    @posts = Post.all
    @post = Post.new
    @post.user_id=current_user.id
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments
    @comment = Comment.new
    @comment.user_id=current_user.id
  end

  def create
    @post = Post.new(post_params)
    @post.user_id=current_user.id
    @post.save
    render :index
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    render :index
  end

  private
  def post_params
    params.require(:post).permit(:content)
  end
end
