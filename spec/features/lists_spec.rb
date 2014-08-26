feature "Lists", :js do
  let(:plan) { create(:plan, month: 1, year: 2014) }

  scenario "viewing an existing list" do
    list = create(:list, plan: plan)
    5.times { |i| create(:list_item, list: list, quantity: i + 1) }

    visit plan_list_path(plan)

    5.times { |i| expect(page).to have_content("#{i + 1} cup milk") }
  end

  scenario "viewing a list that doesn't exist" do
    recipe = create(:recipe)
    create(:ingredient, recipe: recipe)
    create(:meal, plan: plan, recipe: recipe)

    visit plan_list_path(plan)
    expect(page).to have_content('1 cup milk')
  end

  scenario "regenerating a list" do
    list = create(:list, plan: plan)
    create(:list_item, list: list, quantity: 2.0)
    recipe = create(:recipe)
    create(:ingredient, recipe: recipe)
    create(:meal, plan: plan, recipe: recipe)

    visit plan_list_path(plan)
    expect(page).to have_content('2 cup milk')
    click_button 'Regenerate Shopping List'
    expect(page).to have_content('1 cup milk')
  end

  scenario "adding an item to a list" do
    list = create(:list, plan: plan)
    create(:list_item, list: list)

    visit edit_plan_list_path(plan)
    find('.icon-plus').click
    fill_in 'item_1_quantity', with: '3'
    fill_in 'item_1_description', with: 'bananas'
    click_button 'Save'

    expect(page).to have_content('3 bananas')
    expect(list.list_items(true).count).to eql(2)
  end

  scenario "removing an item from a list" do
    list = create(:list, plan: plan)
    create(:list_item, list: list)
    create(:list_item, list: list)

    visit edit_plan_list_path(plan)
    find('#item_0').click
    click_button 'Remove'
    click_button 'Save'

    expect(page).to have_content('1 cup milk')
    expect(list.list_items(true).count).to eql(1)
  end
end
