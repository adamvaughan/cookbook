feature "Recipes", :js do
  scenario "listing recipes" do
    5.times { |i| create(:recipe, title: "Test Recipe #{i}") }

    visit root_path

    5.times { |i| expect(page).to have_content("Test Recipe #{i}") }
  end

  scenario "creating a new recipe" do
    visit root_path
    find('.icon-plus').click

    expect(page).to have_content(/New Recipe/i)

    fill_in 'Title', with: 'Bacon and Eggs'
    fill_in 'ingredient_0_quantity', with: '3'
    fill_in 'ingredient_0_measurement', with: 'large'
    fill_in 'ingredient_0_description', with: 'eggs'
    fill_in 'ingredient_1_quantity', with: '2'
    fill_in 'ingredient_1_measurement', with: 'slices'
    fill_in 'ingredient_1_description', with: 'bacon'
    fill_in 'step_0_description', with: 'Cook eggs.'
    fill_in 'step_1_description', with: 'Cook bacon.'
    click_button 'Save'

    expect(page).to have_no_content(/New Recipe/i)
    expect(page).to have_content(/Bacon and Eggs/i)

    recipe = Recipe.last
    expect(recipe.title).to eql('Bacon and Eggs')
    expect(recipe.ingredients.count).to eql(2)
    expect(recipe.steps.count).to eql(2)

    ingredient = recipe.ingredients.first
    expect(ingredient.index).to eql(0)
    expect(ingredient.quantity).to eql('3')
    expect(ingredient.measurement).to eql('large')
    expect(ingredient.description).to eql('eggs')

    ingredient = recipe.ingredients.last
    expect(ingredient.index).to eql(1)
    expect(ingredient.quantity).to eql('2')
    expect(ingredient.measurement).to eql('slices')
    expect(ingredient.description).to eql('bacon')

    step = recipe.steps.first
    expect(step.index).to eql(0)
    expect(step.description).to eql('Cook eggs.')

    step = recipe.steps.last
    expect(step.index).to eql(1)
    expect(step.description).to eql('Cook bacon.')
  end

  scenario "editing a recipe" do
    recipe = create(:recipe)
    create(:ingredient, recipe: recipe)
    create(:step, recipe: recipe)

    visit recipe_path(recipe)
    find('.icon-edit').click

    expect(page).to have_content(/Edit Recipe/i)

    fill_in 'Title', with: 'Testing'

    within('.ingredient-0') do
      click_button 'Remove'
    end

    within('.step-0') do
      click_button 'Remove'
    end

    fill_in 'ingredient_0_quantity', with: '3'
    fill_in 'ingredient_0_measurement', with: 'large'
    fill_in 'ingredient_0_description', with: 'eggs'
    fill_in 'step_0_description', with: 'Cook eggs.'
    click_button 'Save'

    expect(page).to have_no_content(/Edit Recipe/i)
    expect(page).to have_content(/Testing/i)

    recipe = Recipe.last
    expect(recipe.title).to eql('Testing')
    expect(recipe.ingredients.count).to eql(1)
    expect(recipe.steps.count).to eql(1)

    ingredient = recipe.ingredients.first
    expect(ingredient.index).to eql(0)
    expect(ingredient.quantity).to eql('3')
    expect(ingredient.measurement).to eql('large')
    expect(ingredient.description).to eql('eggs')

    step = recipe.steps.first
    expect(step.index).to eql(0)
    expect(step.description).to eql('Cook eggs.')
  end

  scenario "deleting a recipe" do
    recipe = create(:recipe)

    visit recipe_path(recipe)
    find('.icon-trash').click
    click_button 'Yes'

    expect(page).to have_content(/Recipes/i)
    expect(page).to have_no_content('Test Recipe')
    expect(Recipe.count).to be_zero
  end
end
