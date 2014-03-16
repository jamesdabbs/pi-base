require 'activerecord-import'

class Importer
  class Buffer
    def initialize klass, size: 500
      @buffer, @ids, @klass, @size = [], [], klass, size

      yield self
      flush
    end

    def << attrs
      @buffer << attrs
      flush if @buffer.size == @size
    end

    def flush
      return if @buffer.empty?
      cols = @buffer.first.keys
      vals = @buffer.map { |row| row.values_at *cols }
      @klass.import_without_validations_or_callbacks cols, vals
      @buffer = []
    end
  end
end
