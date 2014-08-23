class Recipe < ActiveRecord::Base
  has_many :ingredients, dependent: :destroy
  has_many :steps, dependent: :destroy

  validates :title, presence: true

  accepts_nested_attributes_for :ingredients, :steps, allow_destroy: true

  default_scope { order(:title).includes(%i(ingredients steps)) }

  before_validation :set_ingredient_indexes
  before_validation :set_step_indexes

  def set_ingredient_indexes
    index = 0

    ingredients.each do |ingredient|
      unless ingredient.marked_for_destruction?
        ingredient.index = index
        index += 1
      end
    end
  end

  def set_step_indexes
    index = 0

    steps.each do |step|
      unless step.marked_for_destruction?
        step.index = index
        index += 1
      end
    end
  end
end
