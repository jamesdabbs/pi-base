class SpacesController < ObjectsController
  @object_class = Space

  def related
    traits = @space.traits.includes :property, :value
    render json: {
      "Manually Added"          => traits.direct,
      "Automatically Generated" => traits.deduced,
      "Needing Proofs"          => traits.unproven
    }
  end

  def proofs
    @space = Space.find params[:space_id]
    respond_to do |format|
      format.html
      format.json { render json: @space.proof_tree }
    end
  end
end
