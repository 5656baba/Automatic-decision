class SearchController < ApplicationController
  require 'miyabi'

  def search
    @keywords = params[:keywords].gsub(/　/, " ").strip
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

    recipe_lists = recipe_ingredients.group(:id).having('count(*) >= 2').pluck(:id)
    recipes = []
    recipe_lists.each do |recipe_list|
      recipes.push(recipe_list.recipe)
    end
    recipes_order = recipes.sort_by! { |v| v.recipe_ingredients.count }
    @recipes = Kaminari.paginate_array(recipes_order).page(params[:page]).per(15)
    @quantity = recipes.count
  end
end
