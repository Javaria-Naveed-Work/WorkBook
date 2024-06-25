class Post < ApplicationRecord
  belongs_to :user, counter_cache: true
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  mount_uploader :pic, PicUploader

  validates :content, presence: true
end
