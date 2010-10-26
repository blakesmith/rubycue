module RubyCue
  class Cuesheet
    attr_reader :cuesheet, :songs

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
      @songs = parse_titles.map{|title| {:title => title}}
      @songs.each_with_index do |song, i|
        song[:performer] = parse_performers[i]
        song[:track] = parse_tracks[i]
        song[:index] = parse_indices[i]
      end
    end

    def position(value)
      index = Index.new(value)
      return @songs.first if index < @songs.first[:index]
      @songs.each_with_index do |song, i|
        return song if song == @songs.last
        return song if between(song[:index], @songs[i+1][:index], index)
      end
    end

    private

    def between(a, b, position_index)
      (position_index > a) && (position_index < b)
    end

    def parse_titles
      unless @titles
        @titles = cuesheet_scan(:title).map{|title| title.first}
        @titles.delete_at(0)
      end
      @titles
    end

    def parse_performers
      unless @performers
        @performers = cuesheet_scan(:performer).map{|performer| performer.first}
        @performers.delete_at(0)
      end
      @performers
    end

    def parse_tracks
      @tracks ||= cuesheet_scan(:track).map{|track| track.first.to_i}
    end

    def parse_indices
      @indices ||= cuesheet_scan(:index).map{|index| RubyCue::Index.new([index[0].to_i, index[1].to_i, index[2].to_i])}
    end

    def cuesheet_scan(field)
      @cuesheet.scan(@reg[field])
    end

  end
end
