class TheoremExploreJob
  @queue = :theorem

  def self.perform id
    t = Theorem.find id
    Theorem::Examiner.new(t).explore
  end
end