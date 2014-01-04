require 'spec_helper'

describe UserAction do
  it "is valid" do
    expect(FactoryGirl.build(:user_action)).to be_valid
  end
end
