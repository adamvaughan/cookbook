describe Recipe do
  let(:recipe) { Recipe.new }

  it "sets ingredient indexes before validation" do
    recipe.ingredients << Ingredient.new
    recipe.ingredients << Ingredient.new
    recipe.valid?

    expect(recipe.ingredients.first.index).to eql(0)
    expect(recipe.ingredients.last.index).to eql(1)
  end

  it "sets step indexes before validation" do
    recipe.steps << Step.new
    recipe.steps << Step.new
    recipe.valid?

    expect(recipe.steps.first.index).to eql(0)
    expect(recipe.steps.last.index).to eql(1)
  end
end
