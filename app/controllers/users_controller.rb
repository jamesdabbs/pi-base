class UsersController < ApplicationController
  def show
    @user = User.find params[:id]
    @edits = Version.where(whodunnit: @user.id).order(created_at: :desc).paginate page: params[:page], per_page: 10
  end
end