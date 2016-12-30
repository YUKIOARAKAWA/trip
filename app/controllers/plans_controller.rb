class PlansController < ApplicationController
  before_action :set_plan, only: [:show, :member, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :member_only, only: [:member, :edit, :update, :destroy]

  # GET /plans
  # GET /plans.json
  def index
    @plans = Plan.where(search_params)
    @areaname = Area.find(search_params[:area_id]).name
  end

  # GET /plans/1
  # GET /plans/1.json
  def show
    @members = @plan.users
    @place = Place.new
    @place.pins.build
    @places = @plan.places.order(:route)

    i = 1
    @hash = Gmaps4rails.build_markers(@places) do |place, marker|
      marker.lat place.latitude
      marker.lng place.longitude
      marker.infowindow "場所：#{place.address}<br>希望者：#{place.user.name}<br>
                        行きたい度：#{place.show_star}<br>コメント：#{place.pins[0].comment}"
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

    if @members.ids.include?(current_user.id)
      render "show"
    else
      render "plan_reference"
    end

  end

  def add
    @place = Place.new(place_params)
    @place.set_route(params[:place][:plan_id])
    respond_to do |format|
      if @place.valid?
        if @place.latitude.nil?
          format.html { redirect_to ({action: 'show', id: @place.plan.id }), alert: '存在する場所を入力してください' }
        else
          @place.save
          format.html { redirect_to ({action: 'show', id: @place.plan.id }), notice: '追加しました' }
          format.json { render :show, status: :created, location: @place }
        end
      else
        #format.html { render :new }
        format.html { redirect_to ({action: 'show', id: @place.plan.id }), alert: '場所が入力されていません' }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  def member
    @plan_user = @plan.plan_users.build
    @members = @plan.users
    @joined_members_ids = @plan.users.ids
    @flg = params[:flg]
  end

  def add_member
    @plan_user = PlanUser.new(plan_user_params)
    @plan = @plan_user.plan
    member_only
    respond_to do |format|
      if @plan_user.save
        # deliverメソッドを使って、メールを送信する
        MemberMailer.join_plan_email(plan_user_params[:user_id],plan_user_params[:plan_id],current_user).deliver

        format.html { redirect_to ({action: 'member', id: @plan_user.plan_id }) }
        format.json { render :show, status: :created, location: @plan_user }
      else
        format.html { render :member }
        format.json { render json: @plan_user.errors, status: :unprocessable_entity }
      end
    end
  end

  def datetime
    @place = Place.find(datatime_params[:id])
    #  binding.pry
    respond_to do |format|
      if @place.update(datatime_params)
        format.html { redirect_to plan_path(@place.plan_id), notice: '時間を更新しました' }
        format.json { render :show, status: :ok, location: @plan }
        format.js
      else
        #未完成
        format.html { render :edit }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  def confirm
    #binding.pry
    @plan = Plan.find(params[:id])
    @members = @plan.users
    @places = @plan.places.order(:route)
  end

  def pdf
    #binding.pry
    respond_to do |format|
    format.html { redirect_to :action => 'pdf', :format => 'pdf', debug: 1 }
    format.pdf do
      @plan = Plan.find(params[:id])
      @places = @plan.places.order(:route)
      render pdf: 'pdf',
       layout: 'pdf_layout.html.erb',
       encoding: 'UTF-8',
       no_background: false
     end
   end
  end

  def finish_mail
    @plan = Plan.find(params[:id])
    members = @plan.users

    # deliverメソッドを使って、メールを送信する。メンバー全員に送信する
    members.each do |member|
      MemberMailer.plan_finish_email(@plan,member).deliver
    end

    respond_to do |format|
      format.html { redirect_to confirm_plan_path(@plan), notice: '送信しました' }
    end

  end


  # GET /plans/new
  def new
    @plan = Plan.new
  end

  # GET /plans/1/edit
  def edit
    @members = @plan.users
  end

  # POST /plans
  # POST /plans.json
  def create
    @plan = Plan.new(plan_params)
    respond_to do |format|
      if @plan.save
        PlanUser.create(plan_id: @plan.id, user_id: current_user.id)
        format.html { redirect_to ({action: 'member', id: @plan.id , flg: 'new'}) }
      # format.html { redirect_to @plan, notice: 'Plan was successfully created.' }
        format.json { render :show, status: :created, location: @plan }
      else
        format.html { render :new }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /plans/1
  # PATCH/PUT /plans/1.json
  def update
    respond_to do |format|
      if @plan.update(plan_params)
        format.html { redirect_to @plan, notice: '基本情報を編集しました' }
        format.json { render :show, status: :ok, location: @plan }
      else
        format.html { render :edit }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plans/1
  # DELETE /plans/1.json
  def destroy
    @plan.destroy
    respond_to do |format|
      format.html { redirect_to plans_url, notice: 'Plan was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def modal_restaurant
    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_plan
      @plan = Plan.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def plan_params
      params.require(:plan).permit(:name, :start_date, :end_date, :area_id)
    end

    def place_params
      params.require(:place).permit(:user_id, :plan_id, :address, :latitude, :longitude, :route,
                                    pins_attributes: [:comment, :want])
    end

    def plan_user_params
      params.require(:plan_user).permit(:user_id, :plan_id)
    end

    def datatime_params
      params.require(:place).permit(:from, :to, :id)
    end

    def search_params
      params.require(:plan).permit(:area_id)
    end


end
