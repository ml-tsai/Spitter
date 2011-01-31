require 'spec_helper'

describe User do

  before(:each) do
    @example = {:name => "Zarne", :email => "zarne@gcds.com.au"}
  end

  it "should creat a new user" do
    User.create!(@example)
  end

  it "should have a name" do
    @no_name = User.new(@example.merge(:name =>""))
    @no_name.should_not be_valid
  end

  it "should have email" do
    @no_email = User.new(@example.merge(:email => ""))
    @no_email.should_not be_valid
  end

  it "should have name no more than 50 chars" do
    long_name = "z" * 51
    @long_name = User.new(@example.merge(:name => long_name))
    @long_name.should_not be_valid
  end

  it "should have a unique valid email" do

  end

end
 