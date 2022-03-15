class User::PostRecipesController < ApplicationController
  before_action :authenticate_user!,except: [:index, :show]

  def new
    @post_recipe=PostRecipe.new
  end

  def index
    @post_recipes=PostRecipe.all.page(params[:page]).per(10)
  end

  def show
    @post_recipe=PostRecipe.find(params[:id])
  end

  def edit
    @post_recipe=PostRecipe.find(params[:id])
  end

  def create
    @post_recipe=PostRecipe.new(post_recipe_params)
    if @post_recipe.save
      redirect_to post_recipe_path(@post_recipe.id)
    else
      render :new
    end
  end

  def updated
    @post_recipe=PostRecipe.find(params[:id])
    if @post_recipe.update(post_recipe_params)
      redirect_to post_recipe_path(@post_recipe.id)
    else
      render :edit
    end
  end

  def destroy
    post_recipe=PostRecipe.find(params[:id])
    post_recipe.destroy
    redirect_to post_recipes_path
  end

  private
  def post_recipe_params
    params.require(:post_recipe).permit(:image, :title, :description, :user_id)
  end
end
