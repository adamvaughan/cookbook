object @list
attribute :id
attribute plan_id: :planId
attribute created_at: :createdAt
attribute updated_at: :updatedAt

child list_items: :items do
  attributes :id, :quantity, :measurement, :description, :purchased
  attribute manually_added: :manuallyAdded
  attribute created_at: :createdAt
  attribute updated_at: :updatedAt
end
