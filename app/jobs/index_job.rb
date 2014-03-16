class IndexJob
  include SuckerPunch::Job

  def perform action, type, id
    case action.to_sym
    when :create, :update
      obj = type.constantize.find id
      return unless obj.indexed?
      Search.index type: type, id: id, body: obj.as_indexed_json
    when :delete
      Search.delete type: type, id: id
    else
      raise ArgumentError, "Unknown action '#{action}'"
    end
  end
end
