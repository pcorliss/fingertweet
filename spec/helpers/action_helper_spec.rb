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
end
