class TraitExploreJob
  include SuckerPunch::Job

  def perform ids
    ActiveRecord::Base.connection_pool.with_connection do
      while id = ids.shift
        nts = Trait.find(id).explore
        ids += [nts].flatten.compact.map(&:id)
      end
    end
  end
end
