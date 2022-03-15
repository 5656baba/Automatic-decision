class Admin::PostsController < ApplicationController
  def index
    @posts=Post.all.page(params[:page]).per(10)
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    render :index
  end
end
