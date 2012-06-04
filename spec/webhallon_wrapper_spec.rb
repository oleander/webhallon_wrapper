describe Webhallon::Client do
  let(:socket) { Webhallon::Client.new("http://localhost:9292") }
  use_vcr_cassette "client"
  
  describe "connected" do
    it "should be connected" do
      socket.should be_connected
    end
  end
end