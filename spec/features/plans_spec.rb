feature "Plans", :js do
  scenario "listing plans" do
    5.times { |i| create(:plan, month: "#{i}", year: 2014) }

    visit plans_path

    expect(page).to have_content('2014')
    expect(page).to have_content('January')
    expect(page).to have_content('February')
    expect(page).to have_content('March')
    expect(page).to have_content('April')
    expect(page).to have_content('May')
  end

  scenario "creating a new plan" do
    visit plans_path
    find('.icon-plus').click
    today = Date.today
    year = today.year - 1

    expect(page).to have_content(/New Meal Plan/i)

    click_button today.year
    click_link year
    click_button today.strftime('%B')
    click_link 'February'
    click_button 'Save'

    expect(page).to have_no_content(/New Meal Plan/i)
    expect(page).to have_content(/February #{year}/i)

    plan = Plan.last
    expect(plan.month).to eql(1)
    expect(plan.year).to eql(year)
  end

  scenario "editing a plan" do
    plan = create(:plan, month: 0)
    today = Date.today

    visit plan_path(plan)
    find('.icon-edit').click

    expect(page).to have_content(/Edit Meal Plan/i)

    click_button 'January'
    click_link 'February'
    click_button 'Save'

    expect(page).to have_no_content(/Edit Meal Plan/i)
    expect(page).to have_content(/February #{today.year}/i)

    plan = Plan.last
    expect(plan.month).to eql(1)
    expect(plan.year).to eql(today.year)
  end

  scenario "deleting a plan" do
    plan = create(:plan)

    visit plan_path(plan)
    find('.icon-trash').click
    click_button 'Yes'

    expect(page).to have_content(/Meal Plans/i)
    expect(page).to have_no_content(Date.today.year)
    expect(Plan.count).to be_zero
  end

  scenario "adding a meal to a plan" do
    plan = create(:plan, month: 0, year: 2014)
    recipe = create(:recipe)

    visit plan_path(plan)
    click_link '15'
    find('.icon-plus').click
    click_link recipe.title
    find('.icon-left-nav').click

    expect(page).to have_content(/January 2014/i)
    # TODO: Not sure why this won't match. "page" appears to be a JSON response at this point.
    # expect(page).to have_css('.day.has-meal')
    expect(plan.meals(true).count).to eql(1)

    meal = plan.meals.first
    expect(meal.day).to eql(15)
    expect(meal.recipe).to eql(recipe)
  end

  scenario "removing a meal from a plan" do
    plan = create(:plan, month: 0, year: 2014)
    recipe = create(:recipe)
    create(:meal, plan: plan, recipe: recipe, day: 15)

    visit plan_path(plan)
    click_link '15'

    expect(page).to have_content(recipe.title)

    find('.table-view-cell').click
    click_button 'Remove'

    expect(page).to have_content(/No meals scheduled for today./i)
    expect(plan.meals(true).count).to be_zero
  end
end
