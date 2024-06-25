class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: 'friend_id'

  validates :user_id, uniqueness: { scope: :friend_id, message: "already exists" }
  enum status: { pending: 'pending', accepted: 'accepted', rejected: 'rejected' }

  after_update :increment_friends_count_cache, if: :status_updated_to_accepted?
  before_destroy :decrement_friends_count_cache

  def increment_friends_count_cache
    user.increment!(:friends_count) if status == 'accepted'
    friend.increment!(:friends_count) if status == 'accepted'
  end

  def decrement_friends_count_cache
    user.decrement!(:friends_count) if status == 'accepted'
    friend.decrement!(:friends_count) if status == 'accepted'
  end

  def status_updated_to_accepted?
    saved_change_to_status?(from: 'pending', to: 'accepted')
  end

  def pending?
    status == 'pending'
  end

end
