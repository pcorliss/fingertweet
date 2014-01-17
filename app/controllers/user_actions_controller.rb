class UserActionsController < ApplicationController

  respond_to :html

  def show
    @actions = UserAction.most_recent_by_user params[:id]
    raise ActiveRecord::RecordNotFound if @actions.empty?
    respond_with @actions
  end
end
