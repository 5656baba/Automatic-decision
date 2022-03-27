require 'rails_helper'

describe '[STEP3] 管理者ログイン後のテスト' do
  let(:admin) { create(:admin) }
  let!(:other_admin) { create(:admin) }
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:other_post) { create(:post, user: other_user) }
  let!(:comment) { create(:comment, post: post, user: user) }
  let!(:other_comment) { create(:comment, post: post, user: other_user) }

  before do
    visit new_admin_session_path
    fill_in 'admin[email]', with: admin.email
    fill_in 'admin[password]', with: admin.password
    click_button 'ログイン'
  end

  describe 'ヘッダーのテスト: 管理者がログインしている場合' do
    context 'リンクの内容を確認' do
      subject { current_path }

      it 'SNS相談一覧を押すと、自分のユーザ詳細画面に遷移する' do
        sns_link = find_all('a')[1].native.inner_text
        sns_link = sns_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link sns_link
        is_expected.to eq '/admin/posts'
      end
      it '会員一覧を押すと、SNS相談一覧に遷移する' do
        users_link = find_all('a')[2].native.inner_text
        users_link = users_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link users_link
        is_expected.to eq '/admin/users'
      end
      it 'コメント一覧を押すと、お問い合わせ画面に遷移する' do
        comments_link = find_all('a')[3].native.inner_text
        comments_link = comments_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link comments_link
        is_expected.to eq '/admin/comments'
      end
    end
  end

  describe 'SNS相談一覧画面のテスト' do
    before do
      visit admin_posts_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/admin/posts'
      end
      it '投稿したユーザー名が表示される' do
        expect(page).to have_content post.user.last_name + ' ' + post.user.first_name
      end
      it '投稿のtitleが表示される' do
        expect(page).to have_content post.title
      end
      it '投稿のcontentが表示される' do
        expect(page).to have_content post.content
      end
      it '投稿の作成時間が表示される' do
        expect(page).to have_content post.created_at.to_s(:datetime_jp)
      end
      it '詳細へのリンク先がそれぞれ正しい' do
        expect(page).to have_link '詳細へ', href: admin_post_path(post.id)
      end
    end

    context '削除リンクのテスト' do
      it '投稿の削除リンクが表示される' do
        expect(page).to have_link '削除する', href: admin_post_path(post.id)
      end
      it '正しく削除される' do
        click_link 'delete_button_id' + post.id.to_s
        expect(Post.where(id: post.id).count).to eq 0
      end
      it 'リダイレクト先が、投稿一覧画面になっている' do
        click_link 'delete_button_id' + post.id.to_s
        expect(current_path).to eq '/admin/posts'
      end
    end
  end

  describe '投稿詳細画面のテスト' do
    before do
      visit admin_post_path(post)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/admin/posts/' + post.id.to_s
      end
      it '「タイトル：」と表示される' do
        expect(page).to have_content 'タイトル：'
      end
      it '「投稿者：」と表示される' do
        expect(page).to have_content '投稿者：'
      end
      it '「投稿日：」と表示される' do
        expect(page).to have_content '投稿日：'
      end
      it '名前が表示される' do
        expect(page).to have_content post.user.last_name + ' ' + post.user.first_name
      end
      it '作成時間が表示される' do
        expect(page).to have_content post.created_at.to_s(:datetime_jp)
      end
      it '投稿のtitleが表示される' do
        expect(page).to have_content post.title
      end
      it '投稿のcontentが表示される' do
        expect(page).to have_content post.content
      end
      it '投稿に紐づくcommentが表示される' do
        expect(page.all('.comment-text').length).to eq post.comments.size
      end
    end

    context '削除リンクのテスト' do
      it '投稿の削除リンクが表示される' do
        expect(page).to have_link 'delete-comment-button' + comment.id.to_s
      end
      it '正しく削除される' do
        click_link 'delete-comment-button' + comment.id.to_s
        expect(Comment.where(id: comment.id).count).to eq 0
      end
      it 'リダイレクト先が、投稿一覧画面になっている' do
        click_link 'delete-comment-button' + comment.id.to_s
        expect(current_path).to eq '/admin/comments'
      end
    end
  end

  describe 'コメント一覧画面のテスト' do
    before do
      visit admin_comments_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/admin/comments'
      end
      it 'コメントしたユーザー名が表示される' do
        expect(page).to have_content comment.user.last_name + ' ' + comment.user.first_name
      end
      it 'コメント先の相談titleが表示される' do
        expect(page).to have_content comment.post.title
      end
      it 'コメントのcommentが表示される' do
        expect(page).to have_content comment.comment
      end
      it '投稿の作成時間が表示される' do
        expect(page).to have_content comment.created_at.to_s(:datetime_jp)
      end
      it '詳細へのリンク先がそれぞれ正しい' do
        expect(page).to have_link comment.comment, href: admin_comment_path(comment.id)
      end
    end

    context '削除リンクのテスト' do
      it '投稿の削除リンクが表示される' do
        expect(page).to have_link 'delete-comment-link' + comment.id.to_s
      end
      it '正しく削除される' do
        click_link 'delete-comment-link' + comment.id.to_s
        expect(Comment.where(id: comment.id).count).to eq 0
      end
      it 'リダイレクト先が、投稿一覧画面になっている' do
        click_link 'delete-comment-link' + comment.id.to_s
        expect(current_path).to eq '/admin/comments'
      end
    end
  end

  describe 'コメント詳細画面のテスト' do
    before do
      visit admin_comment_path(comment)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/admin/comments/' + comment.id.to_s
      end
      it '「コメント先の相談タイトル：」と表示される' do
        expect(page).to have_content 'コメント先の相談タイトル：'
      end
      it '「投稿者：」と表示される' do
        expect(page).to have_content '投稿者：'
      end
      it '「投稿日：」と表示される' do
        expect(page).to have_content '投稿日：'
      end
      it '名前が表示される' do
        expect(page).to have_content comment.user.last_name + ' ' + comment.user.first_name
      end
      it '作成時間が表示される' do
        expect(page).to have_content comment.created_at.to_s(:datetime_jp)
      end
      it 'コメント先の投稿のtitleが表示される' do
        expect(page).to have_content comment.post.title
      end
      it 'コメントのcommentが表示される' do
        expect(page).to have_content comment.comment
      end
    end

    context '削除リンクのテスト' do
      it '投稿の削除リンクが表示される' do
        expect(page).to have_link '削除する', href: admin_comment_path(comment)
      end
      it '正しく削除される' do
        click_link '削除する'
        expect(Comment.where(id: comment.id).count).to eq 0
      end
      it 'リダイレクト先が、投稿一覧画面になっている' do
        click_link '削除する'
        expect(current_path).to eq '/admin/comments'
      end
    end
  end

  describe '会員一覧画面のテスト' do
    before do
      visit admin_users_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/admin/users'
      end
      it '「会員ID」と表示される' do
        expect(page).to have_content '会員ID'
      end
      it '「氏名」と表示される' do
        expect(page).to have_content '氏名'
      end
      it '「メールアドレス」と表示される' do
        expect(page).to have_content 'メールアドレス'
      end
      it '「ステータス」と表示される' do
        expect(page).to have_content 'ステータス'
      end
      it '会員ID]が表示される' do
        expect(page).to have_content user.id
      end
      it '名前が表示される' do
        expect(page).to have_content user.last_name + user.first_name
      end
      it 'メールアドレスが表示される' do
        expect(page).to have_content user.email
      end
      it 'ステータスが表示される' do
        expect(page).to have_content user.is_active == true ? '有効' : '退会'
      end
      it '各ユーザーへのへの詳細リンクが表示される' do
        expect(page).to have_link user.last_name + user.first_name, href: admin_user_path(user)
      end
    end
  end

  describe '会員詳細画面のテスト' do
    before do
      visit admin_user_path(user)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/admin/users/' + user.id.to_s
      end
      it '「ユーザー名さんの会員詳細」と表示される' do
        expect(page).to have_content user.last_name + ' ' + user.first_name + 'さんの会員詳細'
      end
      it '「会員ID」と表示される' do
        expect(page).to have_content '会員ID'
      end
      it '「氏名」と表示される' do
        expect(page).to have_content '氏名'
      end
      it '「フリガナ」と表示される' do
        expect(page).to have_content 'フリガナ'
      end
      it '「メールアドレス」と表示される' do
        expect(page).to have_content 'メールアドレス'
      end
      it '「ステータス」と表示される' do
        expect(page).to have_content 'ステータス'
      end
      it '会員ID]が表示される' do
        expect(page).to have_content user.id
      end
      it '名前が表示される' do
        expect(page).to have_content user.last_name + user.first_name
      end
      it '名前が表示される' do
        expect(page).to have_content user.last_name_kana + user.first_name_kana
      end
      it 'メールアドレスが表示される' do
        expect(page).to have_content user.email
      end
      it 'ステータスが表示される' do
        expect(page).to have_content user.is_active == true ? '有効' : '退会'
      end
      it '編集画面へのリンクが表示される' do
        expect(page).to have_link '編集する', href: edit_admin_user_path(user)
      end
    end
  end

  describe '会員編集画面のテスト' do
    before do
      visit edit_admin_user_path(user)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/admin/users/' + user.id.to_s + '/edit'
      end
      it '「ユーザー名さんの会員情報編集」と表示される' do
        expect(page).to have_content user.last_name + ' ' + user.first_name + 'さんの会員情報編集'
      end
      it '「会員ID」と表示される' do
        expect(page).to have_content '会員ID'
      end
      it '「氏名」と表示される' do
        expect(page).to have_content '氏名'
      end
      it '「フリガナ」と表示される' do
        expect(page).to have_content 'フリガナ'
      end
      it '「メールアドレス」と表示される' do
        expect(page).to have_content 'メールアドレス'
      end
      it '「ステータス」と表示される' do
        expect(page).to have_content 'ステータス'
      end
      it '会員ID]が表示される' do
        expect(page).to have_content user.id
      end
      it '名前編集フォームに自分の名前（姓）が表示される' do
        expect(page).to have_field 'user[last_name]', with: user.last_name
      end
      it '名前編集フォームに自分の名前（名）が表示される' do
        expect(page).to have_field 'user[first_name]', with: user.first_name
      end
      it '名前編集フォームに自分の名前（セイ）が表示される' do
        expect(page).to have_field 'user[last_name_kana]', with: user.last_name_kana
      end
      it '名前編集フォームに自分の名前（メイ）が表示される' do
        expect(page).to have_field 'user[first_name_kana]', with: user.first_name_kana
      end
      it 'メールアドレスが表示される' do
        expect(page).to have_field 'user[email]', with: user.email
      end
      it 'ステータスが表示される' do
        expect(page).to have_content user.is_active == true ? '有効' : '退会'
      end
      it '変更を保存ボタンが表示される' do
        expect(page).to have_button '変更を保存'
      end
    end

    context '更新成功のテスト' do
      before do
        visit edit_admin_user_path(user)
        @user_old_last_name = user.last_name
        @user_old_first_name = user.first_name
        @user_old_last_name_kana = user.last_name_kana
        @user_old_first_name_kana = user.first_name_kana
        @user_old_email = user.email
        fill_in 'user[last_name]', with: Faker::Lorem.characters(number: 5)
        fill_in 'user[first_name]', with: Faker::Lorem.characters(number: 5)
        fill_in 'user[last_name_kana]', with: Faker::Lorem.characters(number: 5)
        fill_in 'user[first_name_kana]', with: Faker::Lorem.characters(number: 5)
        fill_in 'user[email]', with: Faker::Internet.email
        choose('invalid-radio-button')
        click_button '変更を保存'
      end

      it 'last_nameが正しく更新される' do
        expect(user.reload.last_name).not_to eq @user_old_last_name
      end
      it 'last_nameが正しく更新される' do
        expect(user.reload.first_name).not_to eq @user_old_first_name
      end
      it 'last_name_kanaが正しく更新される' do
        expect(user.reload.last_name_kana).not_to eq @user_old_last_name_kana
      end
      it 'first_name_kanaが正しく更新される' do
        expect(user.reload.first_name_kana).not_to eq @user_old_first_name_kana
      end
      it 'emailが正しく更新される' do
        expect(user.reload.email).not_to eq @user_old_email
      end
      it 'is_activeが正しく更新される' do
        expect(User.find_by(email: user.reload.email).is_active).to eq false
      end
      it 'リダイレクト先が、自分のユーザ詳細画面になっている' do
        expect(current_path).to eq '/admin/users/' + user.id.to_s
      end
    end
  end
end
