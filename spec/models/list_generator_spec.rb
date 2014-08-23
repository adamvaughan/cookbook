describe ListGenerator do
  describe ".generate!" do
    let!(:plan) { create(:plan) }
    let!(:recipe_1) { create(:recipe, title: 'Test Recipe 1') }
    let!(:recipe_2) { create(:recipe, title: 'Test Recipe 2') }
    let!(:meal_1) { create(:meal, plan: plan, recipe: recipe_1, day: 1) }
    let!(:meal_2) { create(:meal, plan: plan, recipe: recipe_2, day: 2) }

    it "combines ingredients with the same description and compatible measurements" do
      ingredient_1 = create(:ingredient, recipe: recipe_1, quantity: 1, measurement: 'cup', description: 'sugar')
      ingredient_2 = create(:ingredient, recipe: recipe_2, quantity: 16, measurement: 'ounces', description: 'sugar')

      list = ListGenerator.generate!(plan)
      expect(list.list_items.count).to eql(1)

      list_item = list.list_items.first
      expect(list_item.quantity).to eql(3)
      expect(list_item.measurement).to eql('cups')
      expect(list_item.description).to eql('sugar')
    end

    it "keeps ingredients separate when their measurements are not compatible" do
      ingredient_1 = create(:ingredient, recipe: recipe_1, quantity: 1, measurement: 'cup', description: 'sugar')
      ingredient_2 = create(:ingredient, recipe: recipe_2, quantity: 2, measurement: 'package', description: 'sugar')

      list = ListGenerator.generate!(plan)
      expect(list.list_items.count).to eql(2)

      list_item = list.list_items.find { |list_item| list_item.measurement == 'cup' }
      expect(list_item.quantity).to eql(1)
      expect(list_item.description).to eql('sugar')

      list_item = list.list_items.find { |list_item| list_item.measurement == 'packages' }
      expect(list_item.quantity).to eql(2)
      expect(list_item.description).to eql('sugar')
    end

    it "keeps ingredients separate when they have different descriptions" do
      ingredient_1 = create(:ingredient, recipe: recipe_1, quantity: 1, measurement: 'cup', description: 'sugar')
      ingredient_2 = create(:ingredient, recipe: recipe_2, quantity: 1, measurement: 'tablespoon', description: 'milk')

      list = ListGenerator.generate!(plan)
      expect(list.list_items.count).to eql(2)

      list_item = list.list_items.find { |list_item| list_item.description == 'sugar' }
      expect(list_item.quantity).to eql(1)
      expect(list_item.measurement).to eql('cup')

      list_item = list.list_items.find { |list_item| list_item.description == 'milk' }
      expect(list_item.quantity).to eql(1)
      expect(list_item.measurement).to eql('tablespoon')
    end

    it "combines ingredients with the same description and no measurement" do
      ingredient_1 = create(:ingredient, recipe: recipe_1, quantity: 1, measurement: '', description: 'apple')
      ingredient_2 = create(:ingredient, recipe: recipe_2, quantity: 6, measurement: '', description: 'apples')

      list = ListGenerator.generate!(plan)
      expect(list.list_items.count).to eql(1)

      list_item = list.list_items.first
      expect(list_item.quantity).to eql(7)
      expect(list_item.measurement).to eql('')
      expect(list_item.description).to eql('apples')
    end

    it "handles ingredients that use abbreviations" do
      ingredient_1 = create(:ingredient, recipe: recipe_1, quantity: 1, measurement: 'tablespoon', description: 'milk')
      ingredient_2 = create(:ingredient, recipe: recipe_2, quantity: 2, measurement: 'tbsps', description: 'milk')

      list = ListGenerator.generate!(plan)
      expect(list.list_items.count).to eql(1)

      list_item = list.list_items.first
      expect(list_item.quantity).to eql(3)
      expect(list_item.measurement).to eql('tablespoons')
      expect(list_item.description).to eql('milk')
    end

    it "handles measurements that are not recognized" do
      ingredient_1 = create(:ingredient, recipe: recipe_1, quantity: 1, measurement: 'pinch', description: 'salt')
      ingredient_1 = create(:ingredient, recipe: recipe_1, quantity: 2, measurement: 'pinches', description: 'salt')
      ingredient_1 = create(:ingredient, recipe: recipe_1, quantity: 1, measurement: 'tablespoon', description: 'salt')

      list = ListGenerator.generate!(plan)
      expect(list.list_items.count).to eql(2)

      list_item = list.list_items.find { |list_item| list_item.measurement == 'pinches' }
      expect(list_item.quantity).to eql(3)
      expect(list_item.description).to eql('salt')

      list_item = list.list_items.find { |list_item| list_item.measurement == 'tablespoon' }
      expect(list_item.quantity).to eql(1)
      expect(list_item.description).to eql('salt')
    end
  end
end
