class User::PostsController < ApplicationController
  def index
    @posts = Post.all
    @post = Post.new
    @post.user_id = current_user.id
  end

  def show
    @post = Post.find(params[:id])
    @comments = Comment.includes([:user]).where(post_id: @post.id)
    if user_signed_in?
      @comment = Comment.new
    end
  end

  def create
    @post = Post.new(post_params)
    @post.user_id=current_user.id
    if @post.save
      redirect_to posts_path
    else
      render :index
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end

  private
  def post_params
    params.require(:post).permit(:content, :title)
  end
end
