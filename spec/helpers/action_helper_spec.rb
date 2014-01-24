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
      expect(embed_links(sample_text)).to eq(sample_text)
    end

    it "returns linked http content with nofollows" do
      sample_text = 'This is a sample with a link http://www.google.com/foo?asdf=bar'
      expected_text = 'This is a sample with a link ' +
        '<a href="http://www.google.com/foo?asdf=bar" rel="nofollow">' +
        'http://www.google.com/foo?asdf=bar</a>'
      expect(embed_links(sample_text)).to eq(expected_text)
    end

  end

  describe "#strip_twitter_to" do
    it "removes the @FingerTweeter from the tweet" do
      sample_text = "@FingerTweeter  This show is cool"
      expect(strip_twitter_to(sample_text)).to eq("This show is cool")
    end
  end

  describe "#sanitize_content" do
    it "embeds links and strips twitter to" do
      sample_text = "I just ate a fantastic burger from http://t.co/KNoCuZ6nSU @FingerTweeter"
      expected_text = 'I just ate a fantastic burger from <a href="http://t.co/KNoCuZ6nSU" rel="nofollow">http://t.co/KNoCuZ6nSU</a>'
      expect(sanitize_content(sample_text)).to eq(expected_text)
    end
  end
end
