class Api::V1::ArticlePreviewSerializer < ActiveModel::Serializer
  #index
  attributes  :id, :title, :updated_at
  belongs_to :user, serializer: Api::V1::UserSerializer
end
