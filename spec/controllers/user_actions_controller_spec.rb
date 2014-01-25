require 'spec_helper'

describe UserActionsController do
  describe '#show' do
    it "lookup via twitter_user" do
      user = FactoryGirl.create(:user)
      action = FactoryGirl.create(:user_action, user: user)
      get :show, :id => 'pcorliss_fake'
      expect(assigns(:actions)).to eq([action])
    end

    it "returns a 404 if there are no records for the twitter_user" do
      expect do
        get :show, :id => 'does_not_exist'
      end.to raise_error ActiveRecord::RecordNotFound
    end
  end

  describe "#index" do
    it "finds the 10 most recent actions" do
      user_actions = 10.times.map { FactoryGirl.create(:user_action) }
      get :index
      expect(assigns(:actions)).to eq(user_actions.reverse)
    end
  end

  describe "#reindex" do
    before do
      request.env["HTTP_REFERER"] = '/'
    end

    it "pulls in the latest tweets from twitter" do
      VCR.use_cassette("twitter", :record => :new_episodes) do
        expect do
          post :reindex
        end.to change { UserAction.count }.from(0).to(1)
      end
    end

    it "redirects back" do
      VCR.use_cassette("twitter", :record => :new_episodes) do
        post :reindex
        response.should redirect_to '/'
      end
    end
  end
end
