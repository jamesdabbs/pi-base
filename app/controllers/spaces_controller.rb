class SpacesController < ObjectsController
  @object_class = Space

  def proofs
    @space = Space.find params[:space_id]
    respond_to do |format|
      format.html
      format.json { render json: @space.proof_tree }
    end
  end
end
