class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  mount_uploader :cover_photo, CoverPhotoUploader
  mount_uploader :profile_photo, ProfilePhotoUploader

  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :friendships, dependent: :destroy
  has_many :friends, -> { where(friendships: { status: 'accepted' }) }, through: :friendships

  # Friends that have added you
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id', dependent: :destroy
  has_many :inverse_friends, -> { where(friendships: { status: 'accepted' }) }, through: :inverse_friendships, source: :user

  def all_friends
    # friends + inverse_friends

    friend_ids = friendships.strict_loading!(mode: :n_plus_one_only).where(status: 'accepted').pluck(:friend_id)
    inverse_friend_ids = inverse_friendships.where(status: 'accepted').pluck(:user_id)
    User.where(id: friend_ids + inverse_friend_ids)
  end

end
