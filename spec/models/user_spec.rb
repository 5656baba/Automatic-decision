require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { user.valid? }

    let!(:other_user) { create(:user) }
    let(:user) { build(:user) }

    context 'last_nameカラム' do
      it '空欄でないこと' do
        user.last_name = ''
        is_expected.to eq false
      end
    end
    context 'first_nameカラム' do
      it '空欄でないこと' do
        user.last_name_kana = ''
        is_expected.to eq false
      end
    end
    context 'last_name_kanaカラム' do
      it '空欄でないこと' do
        user.first_name = ''
        is_expected.to eq false
      end
    end
    context 'first_name_kanaカラム' do
      it '空欄でないこと' do
        user.first_name_kana = ''
        is_expected.to eq false
      end
    end
    context 'emailカラム' do
      it '空欄でないこと' do
        user.email = ''
        is_expected.to eq false
      end
      it '一意性があること' do
        user.email = other_user.email
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Postモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:posts).macro).to eq :has_many
      end
    end
    context 'Commentモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:comments).macro).to eq :has_many
      end
    end
    context 'Likeモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:likes).macro).to eq :has_many
      end
    end
  end
end
