require 'rails_helper'

describe '[STEP2] ユーザログイン後のテスト' do
  let(:recipe) { create(:recipe) }
  let(:recipe2) { create(:recipe, title: 'ringo', image_id: 'https://www.google.co.jp', url: 'https://www.google.co.jp') }
  let!(:recipe_ingredient) { create(:recipe_ingredient, recipe: recipe) }
  let!(:recipe_ingredient2) { create(:recipe_ingredient, recipe: recipe2, ingredient: 'javascript') }

  context '完全一致検索ができるとき' do
    it '検索ができる' do
      visit root_path
      fill_in 'keywords', with: 'javascript'
      click_button '検索'
      expect(page).to have_content 'ringo'
      expect(page).to have_css '.img-size'
      expect(page).to have_content recipe2.title
      expect(page).to have_content recipe2.url
    end
  end
  context '曖昧検索ができるとき' do
    it '検索ができる' do
      visit root_path
      fill_in 'keywords', with: 'java'
      click_button '検索'
      expect(page).to have_content 'ruby'
      expect(page).to have_content 'ringo'
    end
  end
  context '検索結果0の時' do
    it '検索ができる' do
      visit root_path
      fill_in 'keywords', with: 'banana'
      click_button '検索'
      expect(page).to have_content 'bananaの検索結果：全(0)件'
    end
  end
end
