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

      describe "#to_s" do
        it "renders the index as a string with leading zeroes" do
          index = RubyCue::Index.new([1, 30, 74]).to_s.should == "01:30:74"
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

      describe "#-" do
        it "returns an object of Class Index" do
          index1 = RubyCue::Index.new([0, 30, 0])
          index2 = RubyCue::Index.new([0, 30, 0])

          (index1 - index2).class.should == RubyCue::Index
        end

        it "subtracts two indices with only frames" do
          index1 = RubyCue::Index.new([0, 0, 50])
          index2 = RubyCue::Index.new([0, 0, 25])

          (index1 - index2).to_a.should == [0, 0, 25]
        end

        it "subtracts two indices with minutes" do
          index1 = RubyCue::Index.new([3, 20, 50])
          index2 = RubyCue::Index.new([2, 40, 25])

          (index1 - index2).to_a.should == [0, 40, 25]
        end

        it "subtracts two indices with even minutes" do
          index1 = RubyCue::Index.new([3, 0, 0])
          index2 = RubyCue::Index.new([2, 0, 0])

          (index1 - index2).to_a.should == [1, 0, 0]
        end

      end

      describe "#>" do
        it "returns true for frames" do
          index1 = RubyCue::Index.new([0, 0, 50])
          index2 = RubyCue::Index.new([0, 0, 25])

          (index1 > index2).should be_true
        end

        it "returns true for seconds" do
          index1 = RubyCue::Index.new([0, 30, 50])
          index2 = RubyCue::Index.new([0, 29, 25])

          (index1 > index2).should be_true
        end

        it "returns true for minutes" do
          index1 = RubyCue::Index.new([2, 30, 50])
          index2 = RubyCue::Index.new([1, 29, 25])

          (index1 > index2).should be_true
        end

        it "returns true for the same time" do
          index1 = RubyCue::Index.new([1, 30, 50])
          index2 = RubyCue::Index.new([1, 30, 50])

          (index1 > index2).should be_false
        end
      end

      describe "#<" do
        it "returns false for frames" do
          index1 = RubyCue::Index.new([0, 0, 50])
          index2 = RubyCue::Index.new([0, 0, 25])

          (index1 < index2).should be_false
        end

        it "returns false for seconds" do
          index1 = RubyCue::Index.new([0, 30, 50])
          index2 = RubyCue::Index.new([0, 29, 25])

          (index1 < index2).should be_false
        end

        it "returns false for minutes" do
          index1 = RubyCue::Index.new([2, 30, 50])
          index2 = RubyCue::Index.new([1, 29, 25])

          (index1 < index2).should be_false
        end

        it "returns false for the same time" do
          index1 = RubyCue::Index.new([1, 30, 50])
          index2 = RubyCue::Index.new([1, 30, 50])

          (index1 < index2).should be_false
        end
      end

      describe "#==" do
        it "returns true if they're the same" do
          index1 = RubyCue::Index.new([1, 30, 50])
          index2 = RubyCue::Index.new([1, 30, 50])

          (index1 == index2).should be_true
        end
        
        it "returns false if they're not the same" do
          index1 = RubyCue::Index.new([1, 30, 50])
          index2 = RubyCue::Index.new([1, 30, 51])

          (index1 == index2).should be_false
        end
      end
    end

    describe "#each" do
      it "yields each minute, second, frame value" do
        array = []
        index = RubyCue::Index.new([1, 30, 45])
        index.each do |value|
          array << value
        end

        array.to_a.should == index.to_a
      end
    end

  end
end
