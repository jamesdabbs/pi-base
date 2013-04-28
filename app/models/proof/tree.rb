class Proof
  class Tree
    def initialize space
      @space = space
    end

    def as_json opts={}
      # FIXME: cache by space
      # FIXME: use rabl?
      nodes = @space.traits.includes(:proof).map do |trait|
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

      node_index = Hash[ nodes.each_with_index.map { |n,i| [n[:id], i] } ]

      links = []
      Proof.where(trait_id: @space.traits.pluck(:id)).each do |proof|
        proof.traits.each do |assumption|
          links << {
            source: node_index[assumption.id],
            target: node_index[proof.trait.id]
          }
        end
      end

      { nodes: nodes, links: links }
    end
  end
end