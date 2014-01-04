require 'spec_helper'

describe "routing to user_actions" do
  it "routes /users/:id to user_actions#show" do
    expect(:get => "/users/pcorliss_fake").to route_to(
      :controller => "user_actions",
      :action => "show",
      :id => "pcorliss_fake"
    )
  end
end
