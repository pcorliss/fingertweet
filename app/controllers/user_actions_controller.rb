class UserActionsController < ApplicationController

  respond_to :html

  def show
    @user = User.find_by_twitter_user(params[:id])
    raise ActiveRecord::RecordNotFound unless @user
    @actions = @user.most_recent_actions
    respond_with @actions
  end

  def index
    @actions = UserAction.order(:created_at).reverse_order.includes(:user)
  end

  # POST /reindex
  def reindex
    UserAction.create_recent_user_actions
    redirect_to :back
  end
end
