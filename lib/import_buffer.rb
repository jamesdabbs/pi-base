class ImportBuffer
  def initialize(length=1000, &block)
    @length = length
    @buffer = []
    yield self
    self.write
  end

  def <<(obj)
    @buffer << obj
    write if @buffer.length == @length
  end

  def write
    unless @buffer.empty?
      @buffer.first.class.import @buffer, validate: false
      @buffer.clear
    end
  end
end