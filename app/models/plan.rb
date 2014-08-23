class Plan < ActiveRecord::Base
  has_many :meals, dependent: :destroy
  has_one :list, dependent: :destroy

  validates :month, presence: true,
                    uniqueness: { scope: :year }
  validates :year, presence: true

  accepts_nested_attributes_for :meals, allow_destroy: true

  default_scope { order(:year, :month).includes(:meals) }
end
