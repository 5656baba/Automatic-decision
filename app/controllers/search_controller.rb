class SearchController < ApplicationController
  def search
    #if params[:keyword]

  #@resi = RakutenWebService::Recipe.large_categories.last

    @resipes = RakutenWebService::Recipe.small_categories

  end
end