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
        expect(page).to have_content post.user.last_name +  ' '  + post.user.first_name
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
        click_link '削除する'
        expect(Post.where(post_id: post.id).count).to eq 0
      end
      it 'リダイレクト先が、投稿一覧画面になっている' do
        click_link '削除する'
        expect(current_path).to eq '/admin/posts/'
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
    end

    context '削除リンクのテスト' do
      it '投稿の削除リンクが表示される' do
        expect(page).to have_link '削除', href: admin_comment_path(post.id, comment)
      end
      it '正しく削除される' do
        click_link '削除'
        expect(Post.where(post_id: post.id, comment_id: comment.id).count).to eq 0
      end
      it 'リダイレクト先が、投稿一覧画面になっている' do
        click_link '削除'
        expect(current_path).to eq '/admin/posts/' + post.id.to_s
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
        expect(page).to have_content comment.user.last_name +  ' '  + comment.user.first_name
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
        expect(page).to have_link '削除', href: admin_comment_path(comment.id)
      end
      it '正しく削除される' do
        click_link '削除'
        expect(Comment.where(comment_id: comment.id).count).to eq 0
      end
      it 'リダイレクト先が、投稿一覧画面になっている' do
        click_link '削除'
        expect(current_path).to eq '/admin/comments/'
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
        expect(page).to have_content comment.user.last_name +  ' '  + comment.user.first_name
      end
      it '作成時間が表示される' do
        expect(page).to have_content comment.created_at.to_s(:datetime_jp)
      end
      it 'コメント先の投稿のtitleが表示される' do
        expect(page).to have_content comment.post.title
      end
      it 'コメントののcommentが表示される' do
        expect(page).to have_content comment.comment
      end
    end

    context '削除リンクのテスト' do
      it '投稿の削除リンクが表示される' do
        expect(page).to have_link '削除する', href: admin_comment_path(comment)
      end
      it '正しく削除される' do
        click_link '削除する'
        expect(Comment.where(comment_id: comment.id).count).to eq 0
      end
      it 'リダイレクト先が、投稿一覧画面になっている' do
        click_link '削除する'
        expect(current_path).to eq '/admin/comments'
      end
    end
  end
end