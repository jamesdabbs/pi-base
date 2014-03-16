class UsersController < ApplicationController
  def show
    @user = User.find params[:id]
    @edits = PaperTrail::Version.where(whodunnit: @user.id.to_s).order(created_at: :desc).paginate page: params[:page], per_page: 10
  end
end
