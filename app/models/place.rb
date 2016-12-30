class Place < ActiveRecord::Base
  geocoded_by :address
  after_validation :geocode

  belongs_to :user
  belongs_to :plan
  has_many :pins, dependent: :destroy

  accepts_nested_attributes_for :pins

  validates :address, presence: true


  #　追加されたplaceをプランの最後の設定する
  def set_route(plan_id)
    max_cnt = Plan.find(plan_id).places.count
    self.route = max_cnt + 1
  end

  #　行きたい度に応じて、⭐️を表示させる。
  #　とりあえず、場所にひもづくピンのなかで、一番目の情報を表示する。
  def show_star
    if self.pins[0].want == 0
      "⭐️"
    elsif self.pins[0].want == 1
      "⭐️⭐️"
    else
      "⭐️⭐️⭐️"
    end
  end

end
