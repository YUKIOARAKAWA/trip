class Place < ActiveRecord::Base
  geocoded_by :address

  after_validation :geocode, if: :address_changed?
  belongs_to :user
  belongs_to :plan
  has_many :pins, dependent: :destroy

  accepts_nested_attributes_for :pins

  validates :address, presence: true


  # ルート(順路)の設定
  def set_route
    # planの最後に入れるために登録されている(places + 1)をrouteに設定する
    self.route = plan.places.count + 1
  end

  #　行きたい度に応じて、⭐️を表示させる。
  #　とりあえず、場所にひもづくピンのなかで、一番目の情報を表示する。
  def show_star
    if self.pins[0].present?
      if self.pins[0].want == 0
        "⭐️"
      elsif self.pins[0].want == 1
        "⭐️⭐️"
      else
        "⭐️⭐️⭐️"
      end
    end
  end

end
