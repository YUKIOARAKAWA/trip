class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception

  before_action :set_plan

  # deviceオーバライド
  # ログイン後のリダイレクト先をマイページに変更
  def after_sign_in_path_for(resource)
    top_mypage_path(current_user)
  end

  # 検索フォーム用にプランのインスタンスが必要
  def set_plan
    @plan = Plan.new
  end

  # カレントユーザがプランのメンバーでない場合、マイページにリダイレクトする
  def member_only
    @members = @plan.users
    unless @members.ids.include?(current_user.id)
      redirect_to top_mypage_path(current_user)
    end
  end

  protected

  #　デバイスでnameを更新できるようにする
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) << :name
  end

end
