module PandaStream
  class Encoding
    attr_accessor :created_at, :updated_at, :video_id, :width, :height, :file_size, :id, :profile_id,
                  :extname, :status, :encoding_time, :encoding_progress, :started_encoding_at
    
    def self.find(id, options = {})
      data = Panda.get("/encodings/#{id}.json", options)
      return nil if data.keys.include? "error"
      
      self.from_hash(data)
    end
    
    def self.for_video(video_id, options = {})
      data = Panda.get("/videos/#{video_id}/encodings.json")
      return [] if data.is_a? Hash and data.keys.include? "error"
      
      data.map{|x| self.from_hash(x) }
    end
    
    def url
      Panda.build_url("#{self.id}#{self.extname}")
    end
    
    def thumbs
      return [] if self.status != "success"
      images = []
      7.times do |i|
        images << Panda.build_url("#{self.id}_#{i + 1}.jpg")
      end
      
      images
    end
    
    def self.from_hash(data)
      profile = self.new
      
      data.keys.each do |key|
        profile.send(:"#{key}=", data[key])
      end
      
      profile
    end
  end
end