class User::PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  def index
    @posts = Post.all.page(params[:page]).per(10)

    @count = Post.count
    if user_signed_in?
      @post = Post.new
      @post.user_id = current_user.id
    end
  end

  def show
    @post = Post.find(params[:id])
    @comments = Comment.includes([:user]).where(post_id: @post.id).page(params[:page]).per(10)
    @count = Comment.includes([:user]).where(post_id: @post.id).count
    if user_signed_in?
      @comment = Comment.new
    end
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to posts_path
      flash[:notice] = "投稿に成功しました"
    elsif params[:post][:title] == "" && params[:post][:content] == ""
      @post = Post.new(post_params)
      @post.user_id = current_user.id
      redirect_to posts_path, notice: "タイトル、投稿内容を入力してください"
    elsif params[:post][:content] == ""
      flash.now[:notice] = "投稿内容を入力してください"
      @post = Post.new(post_params)
      @post.user_id = current_user.id
      redirect_to posts_path, notice: "投稿内容を入力してください"
    elsif params[:post][:title] == ""
      @post = Post.new(post_params)
      @post.user_id = current_user.id
      redirect_to posts_path, notice: "タイトルを入力してください"
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
    # if @post.user != current_user
    #   redirect_to new_user_session_path
    # else
    #   @post = Post.find(params[:id])
    #   @post.destroy
    #   redirect_to posts_path
    # end
  end

  private

  def post_params
    params.require(:post).permit(:content, :title)
  end
end
