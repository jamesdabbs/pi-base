class Proof
  class Tree
    def initialize space
      @space = space
    end

    def as_json opts={}
      nodes = @space.traits.map do |trait|
        {
          name:    trait.assumption_description,
          id:      trait.id,
          deduced: trait.deduced?
        }
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