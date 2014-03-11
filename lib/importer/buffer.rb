require 'activerecord-import'

class Importer
  class Buffer
    def initialize klass, size: 500
      @buffer, @ids, @klass, @size = [], [], klass, size

      yield self
      flush
    end

    def << attrs
      @buffer << @klass.new(attrs)
      flush if @buffer.size == @size
    end

    def flush
      return if @buffer.empty?
      @klass.import @buffer, validate: false
      @buffer = []
    end
  end
end
