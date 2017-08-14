class PlacesController < ApplicationController
  before_action :set_place, only: [:destroy]
  before_action :authenticate_user!

  # DELETE /places/1
  # DELETE /places/1.json
  def destroy
    plan_id = Place.find(params[:id]).plan.id
    @place.destroy
    @reorder = Place.where(plan_id: plan_id)
    @reorder.each_with_index {|route, i| Place.update(route, {:route => i + 1})}
    #binding.pry

    #params[:row].each_with_index {|row, i| Place.update(row, {:route => i + 1})}

    respond_to do |format|
      format.html { redirect_to plan_path(plan_id), notice: '削除しました' }
      format.json { head :no_content }
    end
  end

  def reorder
    params[:row].each_with_index {|row, i|
      Place.update(row, {:route => i + 1})
    }
    @place = Place.find(params[:row][0])
    @plan = @place.plan
    @places = @plan.places.order(:route)
    i = 1
    @hash = Gmaps4rails.build_markers(@places) do |place, marker|
      marker.lat place.latitude
      marker.lng place.longitude
      if place.pins[0].present?
        marker.infowindow "場所：#{place.address}<br>希望者：#{place.user.name}<br>
                          行きたい度：#{place.show_star}<br>コメント：#{place.pins[0].comment}"
      end
      marker.picture({
                :url    => "/#{i}.png",
                #:url    => "https://graph.facebook.com/#{place.user.uid}/picture?width=32&height=32",
                :width  => "28.00000000001",
                :height => "21.00000000001"
               })
      marker.json({title: place.address})
      i = i + 1
  #    binding.pry
    end

    @point = []
    @hash.each do |hash|
      temp= []
      temp.push(hash[:lat])
      temp.push(hash[:lng])
      @point.push(temp)
    end
  #  render 'redraw'
  #  render :text => "OK"
  @aaa = {hash: @hash, point: @point}
#    binding.pry
    render :json => @aaa

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_place
      @place = Place.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def place_params
      params.require(:place).permit(:user_id, :plan_id, :address, :latitude, :longitude, :route)
    end
end
