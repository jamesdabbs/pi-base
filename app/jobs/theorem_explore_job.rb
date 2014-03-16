class TheoremExploreJob
  include SuckerPunch::Job

  def perform id
    ActiveRecord::Base.connection_pool.with_connection do
      traits = Theorem.find(id).explore
      TraitExploreJob.new.perform traits unless traits.empty?
    end
  end
end
