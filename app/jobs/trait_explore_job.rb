class TraitExploreJob
  @queue = :trait

  def self.perform id
    t = Trait.find id
    Trait::Examiner.new(t).explore
  end
end