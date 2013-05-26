class Formula
  class Parser
    attr_accessor :conjunction

    def initialize str
      str = str.strip
      if str =~ /^~\s*\(/
        @negated = true
        str.gsub! /^~\s*/, ''
      end
      str = $1 if str =~ /^\((.*[\+\|].*)\)$/

      @scanner = StringScanner.new str
      @result, @depth, @conjuntion = [""], 0, nil

      process!
    end

    def process!
      return [] if @scanner.eos?
      consume until @scanner.eos?
    end

    def subformulae
      @result.map &:strip
    end

    def negated?
      @negated
    end

    def consume
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
      @conjunction ||= @scanner.matched
      raise "Mismatched conjunction" unless @conjunction == @scanner.matched
      @result << ""
    end
  end
end