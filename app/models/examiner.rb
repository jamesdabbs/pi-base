class Examiner
  attr_accessor :obj
  
  def initialize obj
    @obj = obj
  end

  def check
    raise "`check` should implement logic to check for consistency"
  end

  def explore
    raise "`explore` should implement logic to search for new traits or theorems"
  end
end