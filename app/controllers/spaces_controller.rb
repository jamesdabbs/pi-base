class SpacesController < ObjectsController
  @object_class = Space

  before_action :set_space, only: [:related, :proofs]

  def related
    traits = @space.traits.includes :property, :value
    render json: {
      "Manually Added"          => traits.direct,
      "Automatically Generated" => traits.deduced,
      "Needing Proofs"          => []
    }
  end

  def proofs
    respond_to do |format|
      format.html
      format.json { render json: @space.proof_tree }
    end
  end

  private #----------

  def set_space
    @space = Space.find params[:space_id]
  end
end
