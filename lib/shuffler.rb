module Smoothie
  class Shuffler

    attr_reader :seed

    def initialize(values, seed)
      @values = values
      @seed = seed
    end

    def get(opts = {})
      shuffle_values! unless @shuffled

      offset = opts[:offset] || 0 
      limit  = opts[:limit]  || 10

      ranges = get_ranges(offset, offset + limit)
      ranges.map{|range|@values[range]}.reduce(&:+)
    end

    private

    def shuffle_values!
      generator = Random.new(@seed)
      length = @values.length

      @values = @values.dup

      i = length - 1
      while i > 0 do
        swap!(i, generator.rand(i + 1))
        i -= 1
      end

      @shuffled = true
    end

    def swap!(i, j)
      @values[i], @values[j] = @values[j], @values[i]
    end

    # Array ranges for infinite cycling
    def get_ranges(first, last)
      length = @values.length
      first  = first % length
      last   = last  % length

      if last < first
        [(first...length), (0...last)]
      else
        [(first...last)]
      end
    end
  end
end