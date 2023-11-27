class Api::V1::ArticleSerializer < ActiveModel::Serializer
  # show
  attributes :id, :title, :body, :updated_at
  belongs_to :user, serializer: Api::V1::UserSerializer
end
