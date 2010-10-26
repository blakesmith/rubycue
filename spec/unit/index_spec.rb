require File.join(File.dirname(__FILE__), "../spec_helper")

describe RubyCue::Index do
  describe "init" do
    it "allows empty initialization" do
      lambda { RubyCue::Index.new }.should_not raise_error
    end

    it "initializes from an array if specified default" do
      index = RubyCue::Index.new([5, 0, 75])
      index.minutes.should == 5
      index.seconds.should == 0
      index.frames.should == 75
    end

    it "initializes from integer seconds less than a minute" do
      index = RubyCue::Index.new(30)
      index.minutes.should == 0
      index.seconds.should == 30
      index.frames.should == 0
    end

    it "initializes from integer seconds over a minute" do
      index = RubyCue::Index.new(90)
      index.minutes.should == 1
      index.seconds.should == 30
      index.frames.should == 0
    end
    
    it "initializes from integer seconds at a minute" do
      index = RubyCue::Index.new(60)
      index.minutes.should == 1
      index.seconds.should == 0
      index.frames.should == 0
    end

    it "raises an error if the array size is not size 3" do
      lambda { RubyCue::Index.new([0, 0, 0, 0]) }.should raise_error(ArgumentError)
    end

    it "raises an error if not all the array elements are integers" do
      lambda { RubyCue::Index.new([0, "moose", 0]) }.should raise_error(ArgumentError)
    end

    context "conversions" do
      describe "#to_f" do
        it "converts an array value under a minute" do
          index = RubyCue::Index.new([0, 30, 0])
          index.to_f.should == 30.0
        end

        it "converts an array value over a minute" do
          index = RubyCue::Index.new([1, 30, 0])
          index.to_f.should == 90.0
        end

        it "converts an array value over a minute with frames" do
          index = RubyCue::Index.new([1, 30, 74])
          index.to_f.should == (90 + (74 / 75.0)).to_f
        end
      end

      describe "#to_i" do
        it "converts to seconds and rounds down" do
          index = RubyCue::Index.new([0, 30, 74])
          index.to_i.should == 30
        end
      end

      describe "#to_a" do
        it "converts to an array" do
          index = RubyCue::Index.new([1, 2, 3])
          index.to_a.should == [1, 2, 3]
        end
      end
    end

    context "computations" do
      describe "#+" do
        it "returns an object of Class Index" do
          index1 = RubyCue::Index.new([0, 30, 0])
          index2 = RubyCue::Index.new([0, 30, 0])

          (index1 + index2).class.should == RubyCue::Index
        end

        it "adds two indices under a minute" do
          index1 = RubyCue::Index.new([0, 30, 0])
          index2 = RubyCue::Index.new([0, 30, 0])

          (index1 + index2).to_a.should == [1, 0, 0]
        end

        it "adds two indices over a minute" do
          index1 = RubyCue::Index.new([1, 30, 0])
          index2 = RubyCue::Index.new([2, 20, 0])

          (index1 + index2).to_a.should == [3, 50, 0]
        end

        it "adds two indices with frames" do
          index1 = RubyCue::Index.new([1, 30, 50])
          index2 = RubyCue::Index.new([2, 20, 50])

          (index1 + index2).to_a.should == [3, 51, 25]
        end

        it "adds two indices with only frames" do
          index1 = RubyCue::Index.new([0, 0, 50])
          index2 = RubyCue::Index.new([0, 0, 25])

          (index1 + index2).to_a.should == [0, 1, 0]
        end
      end
    end

  end
end
