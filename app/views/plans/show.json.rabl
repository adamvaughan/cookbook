object @plan
attributes :id, :month, :year
attribute created_at: :createdAt
attribute updated_at: :updatedAt

child :meals do
  attributes :id, :day
  attribute recipe_id: :recipeId
  attribute created_at: :createdAt
  attribute updated_at: :updatedAt
end
