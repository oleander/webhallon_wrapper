require "spec_helper"

describe WebhallonWrapper do
  before(:all) do
    @domain = "http://example.com"
  end
  
  before(:each) do
    @whw = WebhallonWrapper.new(@domain)
  end
  
  context "initialize" do
    it "should be possible to pass a valid url" do
      lambda { WebhallonWrapper.new(@domain) }.should_not raise_error
    end
    
    it "should raise an error" do
      lambda { WebhallonWrapper.new("google") }.should raise_error
    end
    
    it "should raise an error" do
      lambda { WebhallonWrapper.new("http://google.com/") }.should raise_error
    end
  end
  
  context "create" do
    before(:each) do
      stub_request(:post, @domain).with(:body => "name=myplaylist")
    end
    
    it "should be able to create a playlist" do
      @whw.create("myplaylist")
    end
    
    after(:each) do
      a_request(:post, @domain).with(:body => "name=myplaylist").should have_been_made.once
    end
  end
  
  context "info" do
    before(:each) do
      @options = {
        name: "myplaylist",
        link: "spotify:user:radiofy.se:playlist:47JbGTR8wxJw0SX0G1CJcS",
        collaborative: true,
        length: 100,
        tracks: ["spotify:track:5XbEpHHrEliVNo2Vbf1Nqk"]
      }
      
      stub_request(:get, @domain + "/myplaylist").to_return(body: JSON.generate(@options))
    end
    
    it "should return info about the playlist {myplaylist}" do
      result = @whw.info("myplaylist")
      @options.each_pair do |method, value|
        result.send(method).should eq(value)
      end
    end
    
    after(:each) do
      a_request(:get, @domain + "/myplaylist").should have_been_made.once
    end
  end
  
  context "info" do
    before(:each) do
      @options = {
        name: "myplaylist",
        link: "spotify:user:radiofy.se:playlist:47JbGTR8wxJw0SX0G1CJcS",
        collaborative: true,
        length: 100,
        tracks: ["spotify:track:5XbEpHHrEliVNo2Vbf1Nqk"]
      }
      
      stub_request(:get, @domain + "/myplaylist").to_return(body: JSON.generate(@options))
    end
    
    it "should return info about the playlist {myplaylist}" do
      result = @whw.info("myplaylist")
      @options.each_pair do |method, value|
        result.send(method).should eq(value)
      end
    end
    
    after(:each) do
      a_request(:get, @domain + "/myplaylist").should have_been_made.once
    end
  end
  
  context "delete" do
    before(:each) do      
      stub_request(:delete, @domain + "/myplaylist?index=-123")
    end
    
    it "should be able to delete an index" do
      @whw.delete("myplaylist").index(-123)
    end
    
    after(:each) do
      a_request(:delete, @domain + "/myplaylist?index=-123").should have_been_made.once
    end
  end
end