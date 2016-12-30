class Plan < ActiveRecord::Base
  belongs_to :area
  has_many :places
  has_many :plan_users
  has_many :users, through: :plan_users

  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
end
