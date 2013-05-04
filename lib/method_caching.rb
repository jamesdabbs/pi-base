module MethodCaching

  extend ActiveSupport::Concern

  module ClassMethods
    def cache_method name, opts={}
      define_method "#{name}_with_cache" do
        key  = opts.delete(:key) || "/#{self.class.name}/#{id}-#{updated_at}/"
        opts = opts.merge expires_in: 1.day

        Rails.cache.fetch key, opts do
          send "#{name}_without_cache"
        end
      end

      alias_method_chain name, :cache
    end
  end
end

ActiveRecord::Base.send :include, MethodCaching