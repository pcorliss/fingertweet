require 'spec_helper'

describe UserAction do
  it "is valid" do
    expect(FactoryGirl.build(:user_action)).to be_valid
  end

  describe "#create_recent_user_actions" do
    before do
      # VCR stores the response and uses it for subsequent calls.
      # This stub is needed to authenticate the twitter call the first time.
      # Other users will need a config/local/twitter.yml to write new tests.
      AppConfig.stub(
        twitter: Hashie::Mash.new(
          YAML.load_file(File.join(Rails.root, 'config', 'local', 'twitter.yml'))
        )
      )
      AppConfig.stub(
        actions: Hashie::Mash.new(
          YAML.load_file(File.join(Rails.root, 'config', 'actions.yml'))
        )
      )
    end

    it "creates new UserActions based on twitter api calls to FingerTweeter User" do
      # TODO new_episodes should become once when the query is more set in stone
      VCR.use_cassette("twitter", :record => :new_episodes) do
        expect do
          UserAction.create_recent_user_actions
        end.to change { UserAction.count }.from(0).to(1)
      end
    end

    it "uses the last found id from previous searches to limit the query" do
      VCR.use_cassette("twitter", :record => :new_episodes) do
        UserAction.create_recent_user_actions
        expect do
          UserAction.create_recent_user_actions
        end.to_not change { UserAction.count }
      end
    end

    it "deciphers the action from the tweet text" do
      VCR.use_cassette("twitter", :record => :new_episodes) do
        UserAction.create_recent_user_actions
        expect(UserAction.last.action).to eq('worked')
      end
    end

    # TODO at the moment we don't have enough tweets to check this
    it "handles pagination"

  end

  describe "#discover_action" do
    before do
     AppConfig.stub(
        actions: Hashie::Mash.new(
          YAML.load_file(File.join(Rails.root, 'config', 'actions.yml'))
        )
      )
    end

    it "uses the text of a tweet to discover what action the tweet is describing" do
      expect(UserAction.discover_action("I'm watching the news")).to eq('watched')
    end

    it "recognizes past tense" do
      expect(UserAction.discover_action("I watched the news")).to eq('watched')
    end

    it "returns nil if no match is found" do
      expect(UserAction.discover_action("new cool stuff")).to be_nil
    end
  end
end
