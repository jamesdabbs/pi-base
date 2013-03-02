class SpacesController < ApplicationController
  def index
    @spaces = Space.paginate page: params[:page], per_page: 30
  end

  def show
    @space  = Space.find params[:id]
    @traits = @space.traits.paginate page: params[:page], per_page: 30
  end
end
