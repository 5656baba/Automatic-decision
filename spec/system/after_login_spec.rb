require 'rails_helper'

describe '[STEP2] ユーザログイン後のテスト' do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:other_post) { create(:post, user: other_user) }
  let!(:comment) { create(:comment, post: post, user: user) }
  let!(:other_comment) { create(:comment, post: post, user: other_user) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    context 'リンクの内容を確認' do
      subject { current_path }

      it 'マイページを押すと、自分のユーザ詳細画面に遷移する' do
        mypage_link = find_all('a')[1].native.inner_text
        mypage_link = mypage_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link mypage_link
        is_expected.to eq '/informations/' + user.id.to_s
      end
      it 'SNS相談を押すと、SNS相談一覧に遷移する' do
        sns_link = find_all('a')[2].native.inner_text
        sns_link = sns_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link sns_link
        is_expected.to eq '/posts'
      end
      it 'お問い合わせを押すと、お問い合わせ画面に遷移する' do
        inquiry_link = find_all('a')[3].native.inner_text
        inquiry_link = inquiry_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link inquiry_link
        is_expected.to eq '/contacts/new'
      end
    end
  end

  describe '投稿一覧画面のテスト' do
    before do
      visit posts_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts'
      end
      it '自分の投稿と他人の投稿のタイトルのリンク先がそれぞれ正しい' do
        expect(page).to have_link post.title, href: post_path(post)
        expect(page).to have_link other_post.title, href: post_path(other_post)
      end
      it '自分の投稿と他人の投稿の相談内容のリンク先がそれぞれ正しい' do
        expect(page).to have_link post.content, href: post_path(post)
        expect(page).to have_link other_post.content, href: post_path(other_post)
      end
    end

    context 'サイドバーの確認' do
      it '「投稿する」と表示される' do
        expect(page).to have_content '投稿する'
      end
      it 'titleフォームが表示される' do
        expect(page).to have_field 'post[title]'
      end
      it 'titleフォームに値が入っていない' do
        expect(find_field('post[title]').text).to be_blank
      end
      it 'contentフォームが表示される' do
        expect(page).to have_field 'post[content]'
      end
      it 'contentフォームに値が入っていない' do
        expect(find_field('post[content]').text).to be_blank
      end
      it '投稿するボタンが表示される' do
        expect(page).to have_button '投稿する'
      end
    end

    context '投稿成功のテスト' do
      before do
        fill_in 'post[title]', with: Faker::Lorem.characters(number: 5)
        fill_in 'post[content]', with: Faker::Lorem.characters(number: 20)
      end

      it '自分の新しい投稿が正しく保存される' do
        expect { click_button '投稿する' }.to change(user.posts, :count).by(1)
      end
      it 'リダイレクト先が、投稿の一覧画面になっている' do
        click_button '投稿する'
        expect(current_path).to eq '/posts'
      end
    end
  end

  describe '投稿詳細画面のテスト' do
    before do
      visit post_path(post)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts/' + post.id.to_s
      end
      it '「タイトル」と表示される' do
        expect(page).to have_content 'タイトル'
      end
      it 'ユーザ画像が表示される' do
        expect(page).to have_css('.post_image_factorybot')
      end
      it '名前が表示される' do
        expect(page).to have_content post.user.last_name +  ' '  + post.user.first_name
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
      it '投稿に紐づくcommentを投稿したユーザーの画像が表示される' do
        expect(page).to have_css('.comment_image_factorybot')
      end
    end

    context 'サイドバーの確認' do
      it '「コメントする」と表示される' do
        expect(page).to have_content 'コメントする'
      end
      it 'commentフォームが表示される' do
        expect(page).to have_field 'comment[comment]'
      end
      it 'commentフォームに値が入っていない' do
        expect(find_field('comment[comment]').text).to be_blank
      end
      it 'コメントするボタンが表示される' do
        expect(page).to have_button 'コメントする'
      end
    end

    context '投稿成功のテスト' do
      before do
        fill_in 'comment[comment]', with: Faker::Lorem.characters(number: 25)
      end

      it '自分の新しいコメントが正しく保存される' do
        expect { click_button 'コメントする' }.to change(user.comments, :count).by(1)
      end
    end

    context '削除リンクのテスト' do
      it '投稿の削除リンクが表示される' do
        expect(page).to have_link '削除', href: post_comment_path(post.id ,comment)
      end
      it '正しく削除される' do
        click_link '削除'
        expect(Comment.where(post_id: post.id, id: comment.id).count).to eq 0
      end
      it 'リダイレクト先が、投稿一覧画面になっている' do
        click_link '削除'
        expect(current_path).to eq '/posts/' + post.id.to_s
      end
    end
    context 'いいね機能の確認' do
      before do
        #@post = FactoryBot.create(:post)
        @comment = FactoryBot.create(:comment)
      end
      it 'ユーザーが他のコメントをいいねできる' do
        find('#no_liking').click
        expect(page).to have_selector('#liking', visible: false)
        expect(@comment.likes.count).to eq(1)
      end
      it 'ユーザーが他のコメントのいいねを解除できる' do
        find('#liking').click
        expect(page).to have_selector('#no_liking', visible: false)
        expect(@comment.likes.count).to eq(0)
      end
    end
  end

    describe 'ユーザごとのSNS相談履歴一覧画面のテスト' do
      before do
        visit resume_path(user)
      end

      context '表示内容の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/resumes/' +  user.id.to_s
        end
        it '自分の投稿が表示される' do
          expect(page.all('.user_post_count').length).to eq user.posts.size
        end
        it '自分の投稿への詳細リンクが表示される' do
          expect(page).to have_link '詳細へ', href: post_path(post)
        end
        it '他人の投稿は表示されない' do
          expect(page).not_to have_link '', href: post_path(other_post)
          expect(page).not_to have_content other_post.title
          expect(page).not_to have_content other_post.content
          expect(page).not_to have_content other_post.created_at
        end
      end
    end

    describe 'ユーザごとのコメント一覧画面のテスト' do
      before do
        visit edit_resume_path(user)
      end

      context '表示の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/resumes/' + user.id.to_s + '/edit'
        end
        it 'コメント一覧に自分のコメントした投稿のtitleが表示される' do
          expect(page).to have_content comment.post.title
        end
        it 'コメント一覧に自分のコメントのcommentが表示される' do
          expect(page).to have_content comment.comment
        end
        it '他人の投稿は表示されない' do
          expect(page).not_to have_link '', href: resume_path(other_comment)
          expect(page).not_to have_content other_comment.comment
        end
      end
      context '削除リンクのテスト' do
        it '投稿の削除リンクが表示される' do
          expect(page).to have_link '削除する', href: resume_path(comment)
        end
        it '正しく削除される' do
          click_link '削除する'
          expect(Comment.where(post_id: post.id, id: comment.id).count).to eq 0
        end
        it 'リダイレクト先が、投稿一覧画面になっている' do
          click_link '削除する'
          expect(current_path).to eq '/resumes/' + user.id.to_s + '/edit'
        end
      end
    end

    describe '自分のユーザ情報編集画面のテスト' do
      before do
        visit edit_information_path(user)
      end

      context '表示の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/informations/' + user.id.to_s + '/edit'
        end
        it '名前編集フォームに自分の名前(姓)が表示される' do
          expect(page).to have_field 'user[last_name]', with: user.last_name
        end
        it '名前編集フォームに自分の名前(名)が表示される' do
          expect(page).to have_field 'user[first_name]', with: user.first_name
        end
        it '名前編集フォームに自分の名前(セイ)が表示される' do
          expect(page).to have_field 'user[last_name_kana]', with: user.last_name_kana
        end
        it '名前編集フォームに自分の名前(メイ)が表示される' do
          expect(page).to have_field 'user[first_name_kana]', with: user.first_name_kana
        end
        it 'メールアドレスフォームが表示される' do
          expect(page).to have_field 'user[email]'
        end
        it '編集内容を保存ボタンが表示される' do
          expect(page).to have_button '編集内容を保存'
        end
        it '退会確認画面へのリンクが表示される' do
          expect(page).to have_link '退会する', href: unsubscribe_informations_path
        end
      end

      context '更新成功のテスト' do
        before do
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
          click_button '編集内容を保存'
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
        it 'リダイレクト先が、自分のユーザ詳細画面になっている' do
          expect(current_path).to eq '/informations/' + user.id.to_s
        end
      end
    end

  describe '退会確認画面のテスト' do
    before do
      visit unsubscribe_informations_path
    end
    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/informations/unsubscribe'
      end
      it '「本当に退会しますか？」と表示される' do
        expect(page).to have_content '本当に退会しますか？'
      end
      it '退会するリンクが表示される' do
        expect(page).to have_link '退会する', href: withdraw_informations_path
      end
      it '退会しないリンクが表示される' do
        expect(page).to have_link '退会しない', href: information_path(user)
      end
    end

    context '退会成功のテスト' do
      # before do
      #   click_link '退会する'
      # end
      it 'セッション情報が削除され、トップページに戻ること' do
        click_link '退会する'
        expect(User.find_by(email: user.email).is_active).to eq false
        expect(current_path).to eq '/'
      end
    end
  end
end
