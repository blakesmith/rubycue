require File.join(File.dirname(__FILE__), "../spec_helper")

describe RubyCue::Cuesheet do
  before do
    @cuesheet_file = load_cuesheet("test")
  end

  it "stores the cuesheet string" do
    cuesheet = RubyCue::Cuesheet.new(@cuesheet_file)
    cuesheet.cuesheet.should == @cuesheet_file
  end

  describe "#parse" do
    before do 
      @cuesheet = RubyCue::Cuesheet.new(@cuesheet_file)
    end

    it "has the right first track" do
      @cuesheet.parse!
      @cuesheet.tracks.first[:title].should == "Intro"
    end

    it "has the right amonut of tracks" do
      @cuesheet.parse!
      @cuesheet.tracks.size.should == 53
    end
  end
end
