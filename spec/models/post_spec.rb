require 'rails_helper'

RSpec.describe Post, "モデルに関するテスト", type: :model do
  describe '実際に保存してみる' do
    it "有効な投稿内容の場合は保存されるか" do
      expect(FactoryBot.build(:post)).to be_valid
    end
  end
  context "空白のバリデーションチェック" do
    it "titleが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      post = Post.new(title: '', content:'hoge')
      expect(post).to be_invalid
      expect(post.errors[:title]).to include(I18n.t('errors.messages.blank'))
    end
    it "contentが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      post = Post.new(title: 'hoge', content:'')
      expect(post).to be_invalid
      expect(post.errors[:content]).to include(I18n.t('errors.messages.blank'))
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Post.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context 'commentモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:comments).macro).to eq :has_many
      end
    end
  end
end