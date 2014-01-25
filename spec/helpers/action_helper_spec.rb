require 'spec_helper'

describe ActionHelper do
  describe "#action_icons" do
    {
      listened: 'fa-music',
      ate:      'fa-cutlery',
      watched:  'fa-film',
      worked:   'fa-pencil',
      read:     'fa-book'
    }.each do |action, icon|
      it "returns the #{icon} icon when the #{action} action is passed" do
        expect(action_icons(action)).to eq(icon)
      end
    end

    it "returns fa-question when an unrecognized action is passed" do
      expect(action_icons('foo')).to eq('fa-question')
    end
  end

  describe "#embed_links" do
    it "returns the same text as what went in if there is no http content" do
      sample_text = "This is a sample"
      expect(helper.embed_links(sample_text)).to eq(sample_text)
    end

    it "returns linked http content with nofollows" do
      sample_text = 'This is a sample with a link http://www.google.com/foo?asdf=bar'
      expected_text = 'This is a sample with a link ' +
        '<a href="http://www.google.com/foo?asdf=bar" rel="nofollow">' +
        'http://www.google.com/foo?asdf=bar</a>'
      expect(helper.embed_links(sample_text)).to eq(expected_text)
    end
  end

  describe "#strip_twitter_to" do
    it "removes the @FingerTweeter from the tweet" do
      sample_text = "@FingerTweeter  This show is cool"
      expect(helper.strip_twitter_to(sample_text)).to eq("This show is cool")
    end
  end

  describe "#sanitize_content" do
    it "embeds links and strips twitter to" do
      sample_text = "@pcorliss and I just ate a fantastic burger from http://t.co/KNoCuZ6nSU @FingerTweeter"
      expected_text = '<a href="https://twitter.com/pcorliss">@pcorliss</a> and I just ate a fantastic burger from <a href="http://t.co/KNoCuZ6nSU" rel="nofollow">http://t.co/KNoCuZ6nSU</a>'
      expect(helper.sanitize_content(sample_text)).to eq(expected_text)
    end
  end

  describe "#twitter_linker" do
    it "links to a user's page" do
      user = FactoryGirl.create(:user)
      expected_link = '<a href="/pcorliss_fake">@pcorliss_fake</a>'
      expect(helper.twitter_linker(user.twitter_user)).to eq(expected_link)
    end

    it "links back to twitter if you're on the user's page" do
      user = FactoryGirl.create(:user)
      helper.stub(:current_page? => true)
      expected_link = '<a href="https://twitter.com/pcorliss_fake">@pcorliss_fake</a>'
      expect(helper.twitter_linker(user.twitter_user)).to eq(expected_link)
    end

    it "links to twitter if there is no user in the system" do
      expected_link = '<a href="https://twitter.com/fake_user">@fake_user</a>'
      expect(helper.twitter_linker('fake_user')).to eq(expected_link)
    end
  end
end
