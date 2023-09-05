# frozen_string_literal: true

class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  validates :title, presence:true
  validates :body, presence:true,length:{maximum:200}

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.looks(searches, words)
    if searches == "perfect_match"
      @book = Book.where("title LIKE?", "#{words}")
    else
      @book = Book.where("title LIKE?", "%#{words}%")
    end
  end

end
