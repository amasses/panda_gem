require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe PandaStream::Video do
  before(:each) do
    Time.stub!(:now).and_return(mock("time", :iso8601 => "2009-11-04T17:54:11+00:00"))
    @hash_data = hash_data = {"duration"=>14010, "created_at"=>"2010/06/24 05:46:11 +0000", "original_filename"=>"panda.mp4", "updated_at"=>"2010/06/24 05:46:14 +0000", "source_url"=>nil, "extname"=>".mp4", "id"=>"12345", "audio_codec"=>"aac", "file_size"=>805301, "height"=>240, "fps"=>29, "status"=>"success", "video_codec"=>"h264", "width"=>300} 
  end
  
  it "should return an object when passed a hash" do
    object = PandaStream::Video.from_hash(@hash_data)
    
    object.should be_instance_of(PandaStream::Video)
    
    @hash_data.keys.each do |key|
      object.send(key.to_sym).should == @hash_data[key]
    end
  end
  
  it "should return nil when find is called and an invalid ID is passed" do
    error_data = {"message"=>"Couldn't find Video with ID=12345", "error"=>"RecordNotFound"}
    Panda.should_receive(:get).and_return error_data
    PandaStream::Video.find("nonexistant_ID").should be_nil
  end
  
  it "should return an instance of a video when find is called with a valid id" do
    Panda.should_receive(:get).and_return @hash_data
    
    video = PandaStream::Video.find("12345")
    video.should be_instance_of(PandaStream::Video)
    
    @hash_data.keys.each do |key|
      video.send(key.to_s).should == @hash_data[key]
    end
  end
  
  it "should return an empty array when no videos are returned" do
    Panda.should_receive(:get).with("/videos.json", {}).and_return []
    PandaStream::Video.all.should == []
  end
  
  it "should return an array of videos" do
    
    Panda.should_receive(:get).with("/videos.json", {}).and_return [@hash_data]
    videos = PandaStream::Video.all
    videos.size == 1

    @hash_data.keys.each do |key|
      videos.first.send(key.to_s).should == @hash_data[key]
    end
  end
  
  it "should delete the video if it exists" do
    Panda.should_receive(:delete).with("/videos/12345.json", {}).and_return({"deleted"=>"true"})
    stub = PandaStream::Video.from_hash(@hash_data)
    
    stub.destroy.should == true
  end
  
  it "should raise an exception if the video does not exist and a delete is attempted" do
    Panda.should_receive(:delete).and_return({"message"=>"Couldn't find Video with ID=12345", "error"=>"RecordNotFound"})

    stub = PandaStream::Video.from_hash(@hash_data)
    lambda {stub.destroy }.should raise_error()
  end
end
