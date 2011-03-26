require "spec_helper"

describe WebhallonWrapper do
  before(:all) do
    @domain = "http://example.com"
    
    @options = {
      name: "myplaylist",
      link: "spotify:user:radiofy.se:playlist:47JbGTR8wxJw0SX0G1CJcS",
      collaborative: true,
      length: 100,
      tracks: ["spotify:track:5XbEpHHrEliVNo2Vbf1Nqk"]
    }
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
    
    it "should not raise an error duo to the ending slash" do
      lambda { WebhallonWrapper.new("http://google.com/") }.should_not raise_error
    end
  end
  
  context "create" do
    it "should be able to create a playlist using {create!}" do
      options = @options.merge(collaborative: false)
      stub_request(:post, @domain).to_return(body: JSON.generate(options))
      result = @whw.create("myplaylist")
      options.each_pair do |method, value|
        result.send(method).should eq(value)
      end
      a_request(:post, @domain).with(:body => "name=myplaylist&collaborative=false").should have_been_made.once
    end
    
    it "should be possible to create a collaborative playlist" do
      stub_request(:post, @domain).to_return(body: JSON.generate(@options))
      result = @whw.create("myplaylist", collaborative: true)
      @options.each_pair do |method, value|
        result.send(method).should eq(value)
      end
      a_request(:post, @domain).with(:body => "name=myplaylist&collaborative=true").should have_been_made.once
    end
  end
  
  context "info" do
    before(:each) do      
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
    
    it "should be able to delete an index - reverse" do
      @whw.index(-123).delete("myplaylist")
    end
    
    after(:each) do
      a_request(:delete, @domain + "/myplaylist?index=-123").should have_been_made.once
    end
  end
  
  context "add" do
    before(:each) do      
      stub_request(:post, @domain + '/myplaylist').with(body: "track[]=a&track[]=b&track[]=c&index=1")
    end
    
    it "should be possible to add tracks to a list" do
      @whw.add("a", "b", "c").to("myplaylist").starting_at(1)
      a_request(:post, @domain + '/myplaylist').with(body: "track[]=a&track[]=b&track[]=c&index=1").should have_been_made.once
    end
    
    it "should raise an error if calling #starting_at without #add and #to" do
      lambda { @whw.starting_at(1) }.should raise_error(ArgumentError)
    end
  end
  
  context "alive?" do
    it "should be alive" do
      stub_request(:get, @domain).to_return(:status => 200)
      @whw.should be_alive
    end
    
    it "should not be alive" do
      stub_request(:get, @domain).to_return(:status => 400)
      @whw.should_not be_alive
    end
    
    after(:each) do
      a_request(:get, @domain).should have_been_made.once
    end
  end
end