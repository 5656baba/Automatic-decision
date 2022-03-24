class SearchController < ApplicationController
  require 'miyabi'

  def search
    @keywords = params[:keywords].gsub(/　/," ").strip
    if @keywords.include?(" ")
      keywords_arr = keywords.split(" ")
      recipe_ingredients = []
      keywords_arr.each do |keyword|
        recipe_ingredients += RecipeIngredient.where("ingredient LIKE ?", "%" + keyword + "%")
        recipe_ingredients += RecipeIngredient.where("ingredient LIKE ?", "%" + keyword.to_kana + "%")
        recipe_ingredients += RecipeIngredient.where("ingredient LIKE ?", "%" + keyword.to_hira + "%")
      end
    else
      recipe_ingredients = RecipeIngredient.where("ingredient LIKE ?", "%" + @keywords + "%")
    end

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