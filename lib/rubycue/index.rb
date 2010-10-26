module RubyCue
  class Index
    SECONDS_PER_MINUTE = 60
    FRAMES_PER_SECOND = 75

    attr_reader :minutes, :seconds, :frames

    def initialize(value=nil)
      case value
      when Array
        set_from_array!(value)
      when Integer
        set_from_integer!(value)
      end
    end

    private

    def set_from_array!(array)
      if array.size != 3 || array.any?{|element| !element.is_a?(Integer)}
        raise ArgumentError.new("Must be initialized with an array in the format of [minutes, seconds,frames], all integers")
      end
      @minutes, @seconds, @frames = *array
    end

    def set_from_integer!(seconds)
      @minutes = 0
      @frames = 0
      @seconds = seconds

      while @seconds >= SECONDS_PER_MINUTE
        @minutes += 1
        @seconds -= SECONDS_PER_MINUTE
      end
    end

  end
end
