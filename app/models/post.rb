class Post < ApplicationRecord
  belongs_to :user

  has_many :comments, dependent: :destroy

  validates :title, :content, presence: true
  validates :title, length: { in: 3..50 }
  validates :content, length: { minimum: 5 }
end
