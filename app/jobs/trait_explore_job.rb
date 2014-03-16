class TraitExploreJob
  include SuckerPunch::Job

  def perform ids
    ActiveRecord::Base.connection_pool.with_connection do
      while id = ids.shift
        ids += Trait.find(id).explore.map(&:id)
      end
    end
  end
end
