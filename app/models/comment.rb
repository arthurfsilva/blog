class Comment < ApplicationRecord
  belongs_to :post

  validates :name, :body, presence: true
  validates :body, length: { in: 3..50 }
end
