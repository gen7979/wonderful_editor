# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  article_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_comments_on_article_id  (article_id)
#  index_comments_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (article_id => articles.id)
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe Comment do
  context "bodyを入力したとき" do
    it "コメントが作成される" do
      user = User.create!(name: "foo", email: "foo@example.com", password: "abc123")
      article = Article.create!(title: "aaa", body: "bbb", user_id: user.id)

      comment = Comment.new(body: "abcde", user_id: user.id, article_id: article.id)
      expect(comment.valid?).to be true
    end
  end

  context "bodyを入力していないとき" do
    it "エラーが返る" do
      user = User.create!(name: "foo", email: "foo@example.com", password: "abc123")
      article = Article.create!(title: "aaa", body: "bbb", user_id: user.id)

      comment = Comment.new(user_id: user.id, article_id: article.id)
      expect(comment.invalid?).to be true
      expect(comment.errors.details[:body][0][:error]).to eq :blank
    end
  end
end
