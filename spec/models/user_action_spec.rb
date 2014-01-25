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

    it "sets the last indexed time in memcache" do
      stubbed_time = Time.now
      Time.stub(:now => stubbed_time)
      VCR.use_cassette("twitter", :record => :new_episodes) do
        expect do
          UserAction.create_recent_user_actions
        end.to change { Rails.cache.read('last_tweet_index') }.from(nil).to(stubbed_time)
      end
    end

    # TODO at the moment we don't have enough tweets to check this
    it "handles pagination"

  end

  describe "#discover_action" do
    it "uses the text of a tweet to discover what action the tweet is describing" do
      expect(UserAction.discover_action("I'm watching the news")).to eq('watched')
    end

    it "recognizes past tense" do
      expect(UserAction.discover_action("I watched the news")).to eq('watched')
    end

    it "returns unknown if no match is found" do
      expect(UserAction.discover_action("new cool stuff")).to eq('unknown')
    end

    it "knows the difference between a word containing a tense and the actual tense" do
      expect(UserAction.discover_action("I've ruminated on it")).to eq('unknown')
    end
  end
end
