class Proof
  class Tree
    def initialize space
      @space = space
    end

    # -- Proof trace rendering tools -----

    def root_if_unique trait
      if trait.supporters.length == 1
        trait.supporters.first.assumed_id
      elsif !trait.deduced?
        trait.id
      end
    end

    def nodes
      # FIXME: use rabl?
      @nodes ||= @space.traits.includes(:supporters, :property, :value, :proof => :theorem).map do |trait|
        node = {
          name: trait.name,
          id:   trait.id,
          root: root_if_unique(trait)
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
      { nodes: nodes, links: links }
    end

    # -- Trait deletion tools -----

    def excise trait_id
      trait = @space.traits.find trait_id
      raise "You must excise the root (manually input) trait" if trait.deduced?

      supports = trait.supports.includes(implied: { property: :theorems })
      theorems = supports.flat_map { |t| t.implied.property.theorems }.uniq

      supports.delete_all
      trait.delete

      theorems.each do |t|
        t.apply                @space
        t.contrapositive.apply @space
      end
    end
  end
end