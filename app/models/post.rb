class Post < ApplicationRecord
  belongs_to :user

  validates :title, :content, presence: true
  validates :title, length: { in: 3..50 }
  validates :content, length: { minimum: 5 }
end
