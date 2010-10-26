require File.join(File.dirname(__FILE__), "../spec_helper")

describe RubyCue::Cuesheet do
  before do
    @cuesheet_file = load_cuesheet("test")
  end

  it "stores the cuesheet string" do
    cuesheet = RubyCue::Cuesheet.new(@cuesheet_file)
    cuesheet.cuesheet.should == @cuesheet_file
  end

  describe "#parse!" do
    before do 
      @cuesheet = RubyCue::Cuesheet.new(@cuesheet_file)
      @cuesheet.parse!
    end

    it "has the right first track" do
      @cuesheet.songs.first[:title].should == "Intro"
    end

    it "has the right last track" do
      @cuesheet.songs.last[:title].should == "The Lotus Symphony vs. Uplifting"
    end

    it "has the right first performer" do
      @cuesheet.songs.first[:performer].should == "Essential Mix"
    end

    it "has the right last performer" do
      @cuesheet.songs.last[:performer].should == "Netsky vs. Genetic Bros"
    end

    it "has the right first index" do
      @cuesheet.songs.first[:index].should == [0, 0, 0]
    end

    it "has the right last index" do
      @cuesheet.songs.last[:index].should == [115, 22, 47]
    end

    it "has the right first track" do
      @cuesheet.songs.first[:track].should == 1
    end

    it "has the right last track" do
      @cuesheet.songs.last[:track].should == 53
    end

    it "has the right amonut of tracks" do
      @cuesheet.songs.size.should == 53
    end
  end
end
