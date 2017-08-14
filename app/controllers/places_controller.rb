class PlacesController < ApplicationController
  before_action :set_place, only: [:destroy]
  before_action :authenticate_user!

  def destroy
    @place.destroy
    # 経路(route)を作り直す
    @places = @place.plan.places
    @places.each.with_index(1) {|place, route| place.update(route: route)}

    respond_to do |format|
      format.html { redirect_to plan_path(@place.plan.id), notice: '削除しました' }
    end
  end

  def reorder
    # 経路を再作成
    params[:row].each.with_index(1) {|row, route|
      Place.update(row, {route: route})
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

    def set_place
      @place = Place.find(params[:id])
    end

    def place_params
      params.require(:place).permit(:user_id, :plan_id, :address, :latitude, :longitude, :route)
    end
end
