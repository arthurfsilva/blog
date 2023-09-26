class CommentSerializer
  include JSONAPI::Serializer

  attributes :name, :body
end
