class SearchController < ApplicationController
  def search
    recipe_ingredients = RecipeIngredient.where("ingredient LIKE ?", "%" + params[:keywords] + "%")
    recipes = []
    recipe_ingredients.each do |recipe_ingredient|
      recipes.push(recipe_ingredient.recipe)
    end
    recipes.uniq!
    recipes_order = recipes.sort_by! {|v| v.recipe_ingredients.count}
    @recipes = Kaminari.paginate_array(recipes_order).page(params[:page]).per(15)
    @quantity = recipes.count
  end
end