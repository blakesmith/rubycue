module RubyCue
  class Cuesheet
    attr_reader :cuesheet, :tracks

    def initialize(cuesheet)
      @cuesheet = cuesheet      
      @reg = {
        :track => %r(TRACK (\d{1,3}) AUDIO), 
        :performer => %r(PERFORMER "(.*)"), 
        :title => %r(TITLE "(.*)"), 
        :index => %r(INDEX \d{1,3} (\d{1,3}):(\d{1,2}):(\d{1,2}))
      }
    end

    def parse!
      @tracks = @cuesheet.scan(@reg[:title]).map{|title| {:title => title.first}}
      @tracks.delete_at(0)
    end
  end
end
