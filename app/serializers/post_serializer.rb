class PostSerializer
  include JSONAPI::Serializer

  attributes :title, :content
end
