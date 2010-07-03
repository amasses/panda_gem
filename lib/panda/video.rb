module PandaStream
  class Video
    attr_accessor :id, :original_filename, :extname, :duration, :fps, :audio_codec, :video_codec, 
                  :file_size, :height, :width, :created_at, :updated_at, :status, :source_url
    
    def self.find(id, options = {})
      data = Panda.get("/videos/#{id}.json", options)
      return nil if data.nil? or data.keys.include? "error"
      
      self.from_hash(data)
    end
    
    def self.all(options = {})
      data = Panda.get("/videos.json", options)
      return [] if data.nil?
      
      data.map{|x| self.from_hash(x)}
    end
    
    def destroy(options = {})
      response = Panda.delete("/videos/#{self.id}.json", options)
      return (response["deleted"] == "true") if response.keys.include? "deleted"
      
      raise "#{response["error"]}: #{response["message"]}" if response.keys.include? "error"
    end
    
    def encodings(options = {})
      Encoding.for_video(self.id)
    end
    
    def url
      Panda.build_url("#{self.id}#{self.extname}")
    end
    
    def thumbs
      return [] unless self.status == "success" or self.encodings.empty?
      self.encodings.first.thumbs
    end
    
    def self.from_hash(data)
      video = Video.new
      data.keys.each do |key|
        video.send(:"#{key}=", data[key])
      end
      
      video
    end
  end
end