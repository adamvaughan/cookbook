class ListItem < ActiveRecord::Base
  belongs_to :list

  validates :quantity, presence: true
  validates :description, presence: true
end
