class UsersController < ApplicationController
  def my_portfolio
    @tracked_friends = current_user.friends
  end

  def friends
    @friends = current_user.friends
  end

  def search
    if params[:friend].present?
      @friend = params[:friend]
      if @friend
        respond_to do |format|
          format.js { render partial: 'users/friend_result' }
        end
      else
        respond_to do |format|
          flash.now[:alert] = "Could not find user"
          format.js { render partial: 'users/friend_result' }
        end
      end
    else
      respond_to do |format|
        flash.now[:alert] = "Please enter in a valid friend name or email to search"
        format.js { render partial: 'users/friend_result' }
      end
    end
  end

end
