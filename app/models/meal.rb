class Meal < ActiveRecord::Base
  belongs_to :plan
  belongs_to :recipe

  validates :plan, presence: true
  validates :recipe, presence: true
  validates :day, presence: true
end
