# frozen_string_literal: true

class RelationshipsController < ApplicationController

  def create
    user = User.find(params[:user_id])
    follow = Relationship.new(followed_id: user.id)
    follow.follower_id = current_user.id
    follow.followed_id = user.id
    follow.save
    redirect_back fallback_location: root_path
  end

  def destroy
    user = User.find(params[:user_id])
    follow = Relationship.find_by(followed_id: user.id, follower_id: current_user.id)
    follow.destroy
    redirect_back fallback_location: root_path
  end

end
