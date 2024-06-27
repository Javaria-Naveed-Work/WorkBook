class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post, counter_cache: true

  has_many :replies, class_name: "Comment", foreign_key: :parent_id, dependent: :destroy
  belongs_to :parent, class_name: "Comment", optional: true

  validates :content, presence: true, length: { maximum: 500 }
end
