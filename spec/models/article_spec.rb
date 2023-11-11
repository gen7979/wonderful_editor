# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  body       :text
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe Article do
  context "title,bodyが両方揃っているとき" do
    it "記事が作成される" do
      user = User.create!(name: "foo", email: "foo@example.com", password: "abc123")
      article = Article.new(title: "aaa", body: "bbb", user_id: user.id)
      expect(article.valid?).to be true
    end
  end

  context "title,bodyのいずれかが存在しないとき" do
    it "エラーが返る" do
      user = User.create!(name: "foo", email: "foo@example.com", password: "abc123")
      article = Article.new(title: "aaa", user_id: user.id)
      expect(article.invalid?).to be true
      expect(article.errors.details[:body][0][:error]).to eq :blank
    end
  end
end
