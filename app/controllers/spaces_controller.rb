class SpacesController < ObjectsController
  @object_class = Space

  def related
    deduced, direct = @space.traits.
      includes(:property, :value).
      sort_by { |t| t.property.name }.
      partition { |t| t.deduced? }

    render json: {
      "Manually Added"          => direct,
      "Automatically Generated" => deduced,
      "Needing Proofs"          => direct.select(&:unproven?)
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
