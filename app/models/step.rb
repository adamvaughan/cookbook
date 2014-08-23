class Step < ActiveRecord::Base
  belongs_to :recipe

  validates :index, presence: true,
                    uniqueness: { scope: :recipe }
  validates :description, presence: true

  default_scope { order(:index) }
end
