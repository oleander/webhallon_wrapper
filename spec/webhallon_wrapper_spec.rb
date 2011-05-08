require "spec_helper"

describe WebhallonWrapper do
  before(:all) do
    @domain = "http://example.com"
    
    @options = {
      :name          => "myplaylist",
      :link          => "spotify:user:radiofy.se:playlist:47JbGTR8wxJw0SX0G1CJcS",
      :collaborative => true,
      :length        => 100,
      :tracks        => ["spotify:track:5XbEpHHrEliVNo2Vbf1Nqk"]
    }
  end
  
  before(:each) do
    @ww = WebhallonWrapper.new(@domain)
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
      options = @options.merge(:collaborative => false)
      stub_request(:post, @domain).to_return(:body => JSON.generate(options))
      result = @ww.create("myplaylist", options)
      options.each_pair do |method, value|
        result.send(method).should eq(value)
      end
      body = RUBY_VERSION =~ /1\.8\.7/ ? "collaborative=false&name=myplaylist" : "name=myplaylist&collaborative=false"
      a_request(:post, @domain).with(:body => body).should have_been_made.once
    end
    
    it "should be possible to create a collaborative playlist" do
      stub_request(:post, @domain).to_return(:body =>  JSON.generate(@options))
      result = @ww.create("myplaylist", :collaborative => true)
      @options.each_pair do |method, value|
        result.send(method).should eq(value)
      end
      body = RUBY_VERSION =~ /1\.8\.7/ ? "collaborative=true&name=myplaylist" : "name=myplaylist&collaborative=true"
      a_request(:post, @domain).with(:body => body).should have_been_made.once
    end
    
    it "should be possible to create a playlist, without the collaborative option" do
      stub_request(:post, @domain).to_return(:body =>  JSON.generate(@options))
      result = @ww.create("myplaylist")
      @options.each_pair do |method, value|
        result.send(method).should eq(value)
      end
      a_request(:post, @domain).with(:body => "name=myplaylist").should have_been_made.once
    end
  end
  
  context "info" do
    before(:each) do      
      stub_request(:get, @domain + "/myplaylist").to_return(:body =>  JSON.generate(@options))
    end
    
    it "should return info about the playlist {myplaylist}" do
      result = @ww.info("myplaylist")
      @options.each_pair do |method, value|
        result.send(method).should eq(value)
      end
    end
    
    after(:each) do
      a_request(:get, @domain + "/myplaylist").should have_been_made.once
    end
  end
  
  context "delete" do    
    it "should be able to delete an index" do
      stub_request(:delete, @domain + "/myplaylist?index=-123")
      @ww.delete("myplaylist").index(-123)
      a_request(:delete, @domain + "/myplaylist?index=-123").should have_been_made.once
    end
    
    it "should be able to delete an index - reverse" do
      stub_request(:delete, @domain + "/myplaylist?index=-123")
      @ww.index(-123).delete("myplaylist")
      a_request(:delete, @domain + "/myplaylist?index=-123").should have_been_made.once
    end
    
    it "should be able to delete everything" do
      stub_request(:delete, @domain + "/myplaylist")
      @ww.delete("myplaylist").everything
      a_request(:delete, @domain + "/myplaylist").should have_been_made.once
    end
  end
  
  context "add" do
    before(:each) do      
      stub_request(:post, @domain + '/myplaylist').with(:body =>  "track[]=a&track[]=b&track[]=c&index=1")
    end
    
    it "should be possible to add tracks to a list" do
      @ww.add("a", "b", "c").to("myplaylist").starting_at(1)
      a_request(:post, @domain + '/myplaylist').with(:body =>  "track[]=a&track[]=b&track[]=c&index=1").should have_been_made.once
    end
    
    it "should raise an error if calling #starting_at without #add and #to" do
      lambda { @ww.starting_at(1) }.should raise_error(ArgumentError)
    end
  end
  
  context "rename" do
    before(:each) do      
      stub_request(:post, @domain + '/myplaylist').with(:body =>  "name=Any%20Name")
    end
    
    it "should be possible to add tracks to a list" do
      @ww.rename("myplaylist").to("Any Name")
      a_request(:post, @domain + '/myplaylist').with(:body =>  "name=Any%20Name").should have_been_made.once
    end
  end
  
  context "alive?" do
    it "should be alive" do
      stub_request(:get, @domain).to_return(:status => 200)
      @ww.should be_alive
    end
    
    it "should not be alive" do
      stub_request(:get, @domain).to_return(:status => 400)
      @ww.should_not be_alive
    end
    
    after(:each) do
      a_request(:get, @domain).should have_been_made.once
    end
  end
  
  context "option" do
    it "should be possible to add a timeout" do
      WebhallonWrapper.new(@domain, :timeout => 30).instance_eval do
        @config[:timeout].should == 30
      end
    end
    
    it "should use the default option" do
      WebhallonWrapper.new(@domain).instance_eval do
        @config[:timeout].should == 10
      end
      
      WebhallonWrapper.new(@domain, {}).instance_eval do
        @config[:timeout].should == 10
      end
    end
  end
end