class TheoremExploreJob
  @queue = :theorem

  def self.perform id
    Theorem.find(id).explore
  end
end