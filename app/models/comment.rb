class Comment < ApplicationRecord
  belongs_to :post

  validates :name, :body, presence: true
  validates :name, :body, length: { in: 3..50 }
end
