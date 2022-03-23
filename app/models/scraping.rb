class Scraping < ApplicationRecord
  require 'open-uri'
  require 'nokogiri'

  def self.resipe_list_scrape
    base_url = 'https://cookpad.com'
    search_url = "#{base_url}/search"

    charset = nil
    html = open(search_url) do |f|
      charset = f.charset
      f.read
    end

    doc = Nokogiri::HTML.parse(html, nil, charset)

    more_link = doc.css('.more_link>a')[2]['href']

    recent_url = "#{base_url}#{more_link}"

    sleep rand(1.5..2.0)

    charset = nil
    html = open(recent_url) do |f|
      charset = f.charset
      f.read
    end

    doc_recent = Nokogiri::HTML.parse(html, nil, charset)

    while doc_recent.present? do
      doc_recent.css('.recipe-title').each do |f|
        show_url = "#{base_url}#{f['href']}"

        sleep rand(1.5..2.0)

        charset = nil
        html = open(show_url) do |f|
          charset = f.charset
          f.read
        end

        doc_show = Nokogiri::HTML.parse(html, nil, charset)

        image = doc_show.xpath('//*[@id="main-photo"]/img')[0].attributes["src"].value

        title = doc_show.css('h1')[0].children[0].text

        ingredients = []
        doc_show.xpath('//*[@class="ingredient_name"]').each do |recipe|
          puts ingredients << recipe.children[0].text
        end
        url = show_url
        recipe = Recipe.new(image_id: image, title: title, url: url)
        recipe.save
        ingredients.each do |ingredient|
          materials = RecipeIngredient.new(recipe_id: recipe.id, ingredient: ingredient)
          materials.save
        end
      end
      if doc_recent.css(".next_page").present?
        next_url = "#{base_url}#{doc_recent.css('.next_page')[0]['href']}"
        html = open(next_url) do |f|
          charset = f.charset
          f.read
        end
        doc_recent = Nokogiri::HTML.parse(html, nil, charset)
      else
        doc_recent = nil
      end
    end
  end
end