module PandaStream
  class EncodingProfile
    attr_accessor :created_at, :updated_at, :video_id, :width, :height, :file_size, :id, :profile_id,
                  :extname, :status, :encoding_time, :encoding_process, :started_encoding_at
    
    def self.from_hash(data)
      profile = self.class.new
      
      data.keys.each do |key|
        profile.send(:"#{key}=", data[key])
      end
      
      profile
    end
  end
end