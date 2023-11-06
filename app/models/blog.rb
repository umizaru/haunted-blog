# frozen_string_literal: true

class Blog < ApplicationRecord
  belongs_to :user
  has_many :likings, dependent: :destroy
  has_many :liking_users, class_name: 'User', source: :user, through: :likings

  validates :title, :content, presence: true

  scope :published, -> { where('secret = FALSE') }

  scope :search, lambda { |term|
                   where('title LIKE ? OR content LIKE ?', "%#{term}%", "%#{term}%")
                 }

  scope :default_order, -> { order(id: :desc) }

  def owned_by?(target_user)
    user == target_user
  end

  def self.find_blog(current_user, blog_id)
    if current_user
      current_user.blogs.find_by(id: blog_id, secret: true) || Blog.published.find(blog_id)
    else
      Blog.published.find(blog_id)
    end
  end
end
