require 'spec_helper'

describe User do
  describe "#most_recent_actions" do
    before do
      @me = FactoryGirl.create(:user)
      @pc_reading = FactoryGirl.create(:user_action, user: @me, action: 'read', created_at: 5.minutes.ago)
      @pc_working = FactoryGirl.create(:user_action, user: @me, action: 'worked', created_at: 4.minutes.ago)
    end

    it "returns most recent user actions for only the user specified" do
      FactoryGirl.create(:user_action, user: FactoryGirl.build(:user, twitter_user: 'other'))
      expect(@me.most_recent_actions.to_a).to eq([@pc_working, @pc_reading])
    end

    it "only returns the most recent user action in a particular action group" do
      FactoryGirl.create(:user_action, user: @me, action: 'read', created_at: 1.day.ago)
      FactoryGirl.create(:user_action, user: @me, action: 'worked', created_at: 2.days.ago)
      expect(@me.most_recent_actions.to_a).to eq([@pc_working, @pc_reading])
    end
  end
end
