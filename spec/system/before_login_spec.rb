require 'rails_helper'

describe 'ユーザーログイン前のテスト' do
  let(:contact) { create(:contact) }
  describe 'ヘッダーのテスト: ログインしていない場合' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'Automatic Decisionリンクが表示される: 左上から1番目のリンクが「Automatic Decision」である' do
        home_link = find_all('a')[0].native.inner_text
        expect(home_link).to match(/Automatic Decision/)
      end
      it '新規登録リンクが表示される: 左上から2番目のリンクが「新規登録」である' do
        signup_link = find_all('a')[1].native.inner_text
        expect(signup_link).to match(/新規登録/)
      end
      it 'ログインリンクが表示される: 左上から3番目のリンクが「ログイン」である' do
        login_link = find_all('a')[2].native.inner_text
        expect(login_link).to match(/ログイン/)
      end
      it 'SNS相談リンクが表示される: 左上から4番目のリンクが「SNS相談」である' do
        sns_link = find_all('a')[3].native.inner_text
        expect(sns_link).to match(/SNS相談/)
      end
      it 'お問い合わせリンクが表示される: 左上から5番目のリンクが「お問い合わせ」である' do
        inquiry_link = find_all('a')[4].native.inner_text
        expect(inquiry_link).to match(/お問い合わせ/)
      end
    end

    context 'リンクの内容を確認' do
      subject { current_path }

      it 'Automatic Decisionリンクが表示される' do
        home_link = find_all('a')[0].native.inner_text
        expect(home_link).to match(/Automatic Decision/)
        #home_link = find_all('a')[0].native.inner_text
        #home_link = home_link.delete(' ')
        #home_link.gsub!(/\n/, '')
        #click_link home_link
        #is_expected.to eq '/'
      end
      it '新規登録を押すと、新規登録画面に遷移する' do
        signup_link = find_all('a')[1].native.inner_text
        signup_link = signup_link.delete(' ')
        signup_link.gsub!(/\n/, '')
        click_link signup_link
        is_expected.to eq '/users/sign_up'
      end
      it 'ログインを押すと、ログイン画面に遷移する' do
        login_link = find_all('a')[2].native.inner_text
        login_link = login_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link login_link
        is_expected.to eq '/users/sign_in'
      end
      it 'SNS相談を押すと、SNS相談一覧画面に遷移する' do
        sns_link = find_all('a')[3].native.inner_text
        sns_link = sns_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link sns_link, match: :first
        is_expected.to eq '/posts'
      end
      it 'お問い合わせを押すと、お問い合わせ画面に遷移する' do
        inquiry_link = find_all('a')[4].native.inner_text
        inquiry_link = inquiry_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link inquiry_link, match: :first
        is_expected.to eq '/contacts/new'
      end
    end
  end

  describe 'お問い合わせ画面のテスト' do
    before do
      visit new_contact_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/contacts/new'
      end
      it '「お名前*」と表示される' do
        expect(page).to have_content 'お名前*'
      end
      it '「メールアドレス*」と表示される' do
        expect(page).to have_content 'メールアドレス*'
      end
      it '「お問い合わせ内容*」と表示される' do
        expect(page).to have_content 'お問い合わせ内容*'
      end
      it '名前フォームが表示される' do
        expect(page).to have_field 'contact[name]'
      end
      it 'メールアドレスフォームが表示される' do
        expect(page).to have_field 'contact[email]'
      end
      it 'お問い合わせフォームが表示される' do
        expect(page).to have_field 'contact[message]'
      end
      it '入力内容確認ボタンが表示される' do
        expect(page).to have_button '入力内容確認'
      end
    end
  end

  describe '入力内容確認画面のテスト' do
    before do
      @name = Faker::Lorem.characters(number: 10)
      @email = Faker::Internet.email
      @message = Faker::Lorem.characters(number: 25)
      visit new_contact_path
      fill_in 'contact[name]', with: @name
      fill_in 'contact[email]', with: @email
      fill_in 'contact[message]', with: @message
      click_button '入力内容確認'
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/check'
      end
      it '「お名前：」と表示される' do
        expect(page).to have_content 'お名前：'
      end
      it '「メールアドレス：」と表示される' do
        expect(page).to have_content 'メールアドレス：'
      end
      it '「お問い合わせ内容：」と表示される' do
        expect(page).to have_content 'お問い合わせ内容：'
      end
      it '入力した名前が表示される' do
        expect(page).to have_content @name
      end
      it '入力したメールアドレスが表示される' do
        expect(page).to have_content @email
      end
      it '入力したお問い合わせ内容が表示される' do
        expect(page).to have_content @message
      end
      it '送信ボタンが表示される' do
        expect(page).to have_button '送信'
      end
      it '入力画面に戻るボタンが表示される' do
        expect(page).to have_button '入力画面に戻る'
      end
    end
    context '投稿成功のテスト' do
      before do
        @name = Faker::Lorem.characters(number: 10)
        @email = Faker::Internet.email
        @message = Faker::Lorem.characters(number: 25)
        visit new_contact_path
        fill_in 'contact[name]', with: @name
        fill_in 'contact[email]', with: @email
        fill_in 'contact[message]', with: @message
        click_button '入力内容確認'
      end

      it 'お問い合わせ内容が正しく保存される' do
        expect { click_button '送信' }.to change(Contact, :count).by(1)
      end
    end
  end

  describe '入力画面に戻るのテスト' do
    before do
      @name = Faker::Lorem.characters(number: 10)
      @email = Faker::Internet.email
      @message = Faker::Lorem.characters(number: 25)
      visit new_contact_path
      fill_in 'contact[name]', with: @name
      fill_in 'contact[email]', with: @email
      fill_in 'contact[message]', with: @message
      click_button '入力内容確認'
      click_button '入力画面に戻る'
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/contacts/back'
      end
     it '「お名前*」と表示される' do
        expect(page).to have_content 'お名前*'
      end
      it '「メールアドレス*」と表示される' do
        expect(page).to have_content 'メールアドレス*'
      end
      it '「お問い合わせ内容*」と表示される' do
        expect(page).to have_content 'お問い合わせ内容*'
      end
      it '名前フォームが表示される' do
        expect(page).to have_field 'contact[name]', with: @name
      end
      it 'メールアドレスフォームが表示される' do
        expect(page).to have_field 'contact[email]', with: @email
      end
      it 'お問い合わせフォームが表示される' do
        expect(page).to have_field 'contact[message]', with: @message
      end
      it '入力内容確認ボタンが表示される' do
        expect(page).to have_button '入力内容確認'
      end
    end
  end

  describe 'thanksページのテスト' do
    before do
      visit thanks_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/thanks'
      end
      it '「お問い合わせありがとうございました！」と表示される' do
        expect(page).to have_content 'お問い合わせありがとうございました！'
      end
    end
  end

  describe 'ユーザ新規登録のテスト' do
    before do
      visit new_user_registration_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_up'
      end
      it '「新規会員登録」と表示される' do
        expect(page).to have_content '新規会員登録'
      end
      it '名前(姓)フォームが表示される' do
        expect(page).to have_field 'user[last_name]'
      end
      it '名前(名)フォームが表示される' do
        expect(page).to have_field 'user[first_name]'
      end
      it '名前(セイ)フォームが表示される' do
        expect(page).to have_field 'user[last_name_kana]'
      end
      it '名前(カナ)フォームが表示される' do
        expect(page).to have_field 'user[first_name_kana]'
      end
      it 'メールアドレスフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'パスワード（6文字以上）フォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'パスワード（確認用）フォームが表示される' do
        expect(page).to have_field 'user[password_confirmation]'
      end
      it '新規登録ボタンが表示される' do
        expect(page).to have_button '新規登録'
      end
      it 'ログインリンクが表示される: 画面の最後のリンクが「こちら」である' do
        expect(page).to have_link 'こちら', href: new_user_session_path
      end
    end

    context '新規登録成功のテスト' do
      before do
        fill_in 'user[last_name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[first_name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[last_name_kana]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[first_name_kana]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end

      it '正しく新規登録される' do
        expect { click_button '新規登録' }.to change(User.all, :count).by(1)
      end
      it '新規登録後のリダイレクト先が、トップページになっている' do
        click_button '新規登録'
        expect(current_path).to eq '/'
      end
    end
  end
  describe 'ユーザログイン' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_in'
      end
      it '「ログイン」と表示される' do
        expect(page).to have_content 'ログイン'
      end
      it 'メールアドレスフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'パスワードフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'Log inボタンが表示される' do
        expect(page).to have_button 'ログイン'
      end
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
      end

      it 'ログイン後のリダイレクト先が、トップページになっている' do
        expect(current_path).to eq '/'
      end
    end

    context 'ログイン失敗のテスト' do
      before do
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'ログイン'
      end

      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
    end

    context 'ヘッダーの表示を確認' do
      it 'Automatic Decisionリンクが表示される: 左上から1番目のリンクが「Automatic Decision」である' do
        home_link = find_all('a')[0].native.inner_text
        expect(home_link).to match(/Automatic Decision/)
      end
      it 'マイページリンクが表示される: 左上から2番目のリンクが「マイページ」である' do
        mypage_link = find_all('a')[1].native.inner_text
        expect(mypage_link).to match(/マイページ/)
      end
      it 'SNS相談リンクが表示される: 左上から3番目のリンクが「SNS相談」である' do
        sns_link = find_all('a')[2].native.inner_text
        expect(sns_link).to match(/SNS相談/)
      end
      it 'お問い合わせリンクが表示される: 左上から4番目のリンクが「お問い合わせ」である' do
        inquiry_link = find_all('a')[3].native.inner_text
        expect(inquiry_link).to match(/お問い合わせ/)
      end
      it 'ログアウトリンクが表示される: 左上から5番目のリンクが「ログアウト」である' do
        logout_link = find_all('a')[4].native.inner_text
        expect(logout_link).to match(/ログアウト/)
      end
    end
  end

  describe 'ユーザログアウトのテスト' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
      logout_link = find_all('a')[4].native.inner_text
      logout_link = logout_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
      click_link logout_link
    end

    context 'ログアウト機能のテスト' do
      it '正しくログアウトできている: ログアウト後のリダイレクト先においてログイン画面へのリンクが存在する' do
        expect(page).to have_link '', href: '/users/sign_in'
      end
      it 'ログアウト後のリダイレクト先が、トップになっている' do
        expect(current_path).to eq '/'
      end
    end
  end
end