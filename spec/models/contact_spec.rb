require 'rails_helper'

RSpec.describe Contact, "モデルに関するテスト", type: :model do
  describe '実際に保存してみる' do
    it "有効な投稿内容の場合は保存されるか" do
      expect(FactoryBot.build(:contact)).to be_valid
    end
  end
  context "空白のバリデーションチェック" do
    it "nameが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      contact = Contact.new(name: '', email: 'hoge@hoge.com', message:'hoge')
      expect(contact).to be_invalid
      expect(contact.errors[:name]).to include(I18n.t('errors.messages.blank'))
    end
    it "emailが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      contact = Contact.new(name: 'hoge', email: '', message:'hoge')
      expect(contact).to be_invalid
      expect(contact.errors[:email]).to include(I18n.t('errors.messages.blank'))
    end
    it "messageが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      contact = Contact.new(name: 'hoge', email: 'hoge@hoge.com', message:'')
      expect(contact).to be_invalid
      expect(contact.errors[:message]).to include(I18n.t('errors.messages.blank'))
    end
  end
end
