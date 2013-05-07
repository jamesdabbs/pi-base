class Formula
  class Parser
    def initialize str
      stripped = str =~ /^\((.*[\+\|].*)\)$/ ? $1 : str
      @scanner = StringScanner.new stripped
      @result  = [""]
      @depth   = 0
      @conj    = nil
    end

    def process
      return [] if @scanner.eos?

      until @scanner.eos?
        if scan /\\/
          store
          store_escaped
        elsif scan /[^()+|\\]+/
          store
        elsif scan /\(/
          store unless @depth.zero?
          @depth += 1
        elsif scan /\)/
          @depth -= 1
          store unless @depth.zero?
        elsif scan /[+|]/
          @depth.zero? ? set_conjunction : store
        end
      end

      [@conj, @result.map(&:strip)]
    end

    def scan exp
      @scanner.scan exp
    end

    def store
      @result.last << @scanner.matched
    end

    def store_escaped
      scan /./
      store
    end

    def set_conjunction
      @conj ||= @scanner.matched
      raise "Mismatched conjunction" unless @conj == @scanner.matched
      @result << ""
    end
  end
end