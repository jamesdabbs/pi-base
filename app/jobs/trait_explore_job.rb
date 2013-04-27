class TraitExploreJob
  @queue = :trait

  def self.perform id
    Trait.find(id).explore
  end
end