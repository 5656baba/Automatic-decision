require 'rails_helper'

RSpec.describe Comment, "モデルに関するテスト", type: :model do
  describe '実際に保存してみる' do
    it "有効な投稿内容の場合は保存されるか" do
      expect(FactoryBot.build(:comment)).to be_valid
    end
  end

  context "空白のバリデーションチェック" do
    it "commentが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      comment = Comment.new(comment: '')
      expect(comment).to be_invalid
      expect(comment.errors[:comment]).to include(I18n.t('errors.messages.blank'))
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Comment.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end

    context 'Postモデルとの関係' do
      it 'N:1となっている' do
        expect(Comment.reflect_on_association(:post).macro).to eq :belongs_to
      end
    end

    context 'Likeモデルとの関係' do
      it '1:Nとなっている' do
        expect(Comment.reflect_on_association(:likes).macro).to eq :has_many
      end
    end
  end
end
