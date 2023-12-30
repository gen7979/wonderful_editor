# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  body       :text
#  status     :integer          default("draft"), not null
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
class Article < ApplicationRecord
  # validationの追加
  validates :title, :body, presence: true

  # users
  belongs_to :user
  # article_likes
  has_many :article_likes, dependent: :destroy
  # comments
  has_many :comments, dependent: :destroy
  # 公開非公開の設定
  enum status: { draft: 0, published: 1 }

end
