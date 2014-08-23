object @recipe
attributes :id, :title, :notes
attribute created_at: :createdAt
attribute updated_at: :updatedAt

child :ingredients do
  attributes :id, :index, :quantity, :measurement, :description, :notes
  attribute created_at: :createdAt
  attribute updated_at: :updatedAt
end

child :steps do
  attributes :id, :index, :description
  attribute created_at: :createdAt
  attribute updated_at: :updatedAt
end
