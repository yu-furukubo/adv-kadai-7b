# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:update, :edit]
  before_action :ensure_guest_user, only: [:edit]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    @books_today = @books.where(created_at: Time.zone.now.all_day).count
    @books_yesterday = @books.where(created_at: 1.day.ago.all_day).count
    two_weeks_ago = (Time.current - 13.day).at_beginning_of_day
    one_week_ago = (Time.current - 6.day).at_beginning_of_day
    @books_last_week = @books.where(created_at: two_weeks_ago..(one_week_ago - 1.minute)).count
    @books_this_week = @books.where(created_at: one_week_ago..Time.current).count
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  def search
    @user = User.find(params[:user_id])
    @books = @user.books
    @book = Book.new
    @create_at = params[:created_at]
    @search_books = @books.where(['created_at LIKE ?', "#{@create_at}%"])
  end

  def follow_users
    @user = User.find(params[:id])
    @users = @user.following_users
  end

  def follower_users
    @user = User.find(params[:id])
    @users = @user.followed_users
  end

  private
    def user_params
      params.require(:user).permit(:name, :introduction, :profile_image)
    end

    def book_params
      params.require(:book).permit(:title, :body, :user_id)
    end

    def ensure_correct_user
      @user = User.find(params[:id])
      unless @user == current_user
        redirect_to user_path(current_user)
      end
    end

    def ensure_guest_user
      @user = User.find(params[:id])
      if @user.guest_user?
        redirect_to user_path(current_user), notice: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
      end
    end
end
