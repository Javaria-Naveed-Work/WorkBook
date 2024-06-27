class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  mount_uploader :cover_photo, CoverPhotoUploader
  mount_uploader :profile_photo, ProfilePhotoUploader

  with_options dependent: :destroy do |assoc|
    assoc.has_many :posts
    assoc.has_many :likes
    assoc.has_many :comments

    assoc.has_many :friendships
    #friendships initiated by other user
    assoc.has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id'
  end

  has_many :friends, -> { where(friendships: { status: 'accepted' }) }, through: :friendships
  # Friends that have added you
  has_many :inverse_friends, -> { where(friendships: { status: 'accepted' }) }, through: :inverse_friendships, source: :user

  validates :name, presence: true

  def all_friends

    #uses two join
    friends + inverse_friends

    #User.joins(:friendships)
    #              .where(friendships: { user_id: id, status: 'accepted' })
    #              .or(User.joins(:friendships).where(friendships: { friend_id: id, status: 'accepted' }))

    # Four queries
    # User.joins(:friendships).where(Friendship.table_name => { user_id: id, status: 'accepted' } or { friend_id: id, status: 'accepted' })
    # friend_ids = friendships.where(status: 'accepted').pluck(:friend_id)
    # inverse_friend_ids = inverse_friendships.where(status: 'accepted').pluck(:user_id)
    # User.where(id: friend_ids + inverse_friend_ids)
  end

end
