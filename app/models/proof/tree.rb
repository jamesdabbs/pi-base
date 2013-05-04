class Proof
  class Tree
    def initialize space
      @space = space
    end

    def root_if_unique trait
      if trait.supporters.length == 1
        trait.supporters.first.assumed_id
      elsif !trait.deduced?
        trait.id
      end
    end

    def nodes
      # FIXME: use rabl?
      @nodes ||= @space.traits.includes(:supporters, :proof => :theorem).map do |trait|
        node = {
          name: trait.assumption_description,
          id:   trait.id,
          root: root_if_unique(trait)
        }
        if trait.proof
          node[:theorem] = {
            name: trait.proof.theorem.assumption_description,
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
      { nodes: nodes, links: links }
    end
  end
end