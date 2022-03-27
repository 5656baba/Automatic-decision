require 'rails_helper'

RSpec.describe 'adminモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { admin.valid? }

    let!(:other_admin) { create(:admin) }
    let(:admin) { build(:admin) }

    context 'emailカラム' do
      it '空欄でないこと' do
        admin.email = ''
        is_expected.to eq false
      end
      it '一意性があること' do
        admin.email = other_admin.email
        is_expected.to eq false
      end
    end

    context 'encrypted_passwordカラム' do
      it '空欄でないこと' do
        admin.password = ''
        is_expected.to eq false
      end
    end
  end
end
