class Proof
  class Tree
    def initialize space
      @space = space
    end

    def nodes
      # FIXME: cache theorem names
      # FIXME: use rabl?
      @nodes ||= @space.traits.includes(:property, :value, :proof => :theorem).map do |trait|
        node = {
          name: trait.assumption_description,
          id:   trait.id
        }
        if trait.proof
          node[:theorem] = {
            name: trait.proof.theorem.name,
            id:   trait.proof.theorem_id
          }
        else
          node[:description] = trait.description
        end
        node
      end
    end

    def node_index
      @node_index ||= Hash[ nodes.each_with_index.map { |n,i| [n[:id], i] } ]
    end

    def links
      Proof.where(trait_id: @space.traits.pluck(:id)).includes(:traits).flat_map do |proof|
        proof.traits.map do |assumption|
          {
            source: node_index[assumption.id],
            target: node_index[proof.trait_id]
          }
        end
      end
    end

    def as_json opts={}
      # FIXME: cache tree by space
      { nodes: nodes, links: links }
    end
  end
end