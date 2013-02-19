require 'spec_helper'

describe User do

  before do
    @user = User.new(name: "Example User", 
                     email: "user@example.com",
                     password: "foobar")
  end

  describe "with valid attributes" do
    
    it "should be valid" do
      @user.should be_valid
    end
  
    it "should be valid if it has an encrypted_password but no password" do
      @user.save
      @user.password = nil
      @user.should be_valid
    end
  end
  
  describe "without a name" do
    
    before do
      @user.name = ""
    end
    
    it "should not be valid" do
      @user.should_not be_valid
    end
  end
  
  describe "without an email" do
    
    before do
      @user.email = ""
    end
  
    it "should not be valid" do
      @user.should_not be_valid
    end    
  end
  
  describe "without a password" do
    
    before do
      @user.password = ""
    end
    
    it "should not be valid" do
      @user.should_not be_valid
    end
  end
  
  describe "hashed_password" do
    
    it "should be populated after the user has been saved" do
      @user.save
      @user.hashed_password.should_not be_blank
    end
  end
  
  describe "salt" do
    
    it "should be populated after the user has been saved" do
      @user.save
      @user.salt.should_not be_blank
    end
  end
end