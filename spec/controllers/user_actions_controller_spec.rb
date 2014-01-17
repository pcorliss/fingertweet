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
end
