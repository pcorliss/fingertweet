require 'spec_helper'

describe "routing to user_actions" do
  it "routes /:id to user_actions#show" do
    expect(:get => "/pcorliss_fake").to route_to(
      :controller => "user_actions",
      :action => "show",
      :id => "pcorliss_fake"
    )
  end

  it "routes / to user_actions#index" do
    expect(:get => "/").to route_to(
      :controller => "user_actions",
      :action => "index"
    )
  end
end
