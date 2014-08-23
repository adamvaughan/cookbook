/* global describe, beforeEach, it, expect, spyOn, inject */

'use strict';

describe('Controller: RecipeFormCtrl', function () {
  var controller;
  var rootScope;
  var location;
  var q;
  var recipes;

  beforeEach(module('cookbook'));

  beforeEach(inject(function ($rootScope, $location, $q, Recipes) {
    rootScope = $rootScope;
    location = $location;
    q = $q;
    recipes = Recipes;
  }));

  describe('initialization', function () {
    it('initializes the recipe ingredients and steps when not set', inject(function ($controller) {
      controller = $controller('RecipeFormCtrl', { recipe: { id: 1, title: 'Test Recipe' } });
      expect(controller.recipe).toEqual({ id: 1, title: 'Test Recipe', ingredients: [{}], steps: [{}] });
    }));

    it('adds a blank step and ingredient to the recipe', inject(function ($controller) {
      controller = $controller('RecipeFormCtrl', { recipe: { id: 1, title: 'Test Recipe', ingredients: [{ id: 2 }], steps: [{ id: 3 }] } });
      expect(controller.recipe).toEqual({ id: 1, title: 'Test Recipe', ingredients: [{ id: 2 }, {}], steps: [{ id: 3 }, {}] });
    }));
  });

  describe('visibleIngredients', function () {
    it('does not include ingredients marked for destruction', inject(function ($controller) {
      controller = $controller('RecipeFormCtrl', { recipe: { id: 1, title: 'Test Recipe', ingredients: [{ id: 2 }, { id: 3, _destroy: '1' }] } });
      expect(controller.visibleIngredients()).toEqual([{ id: 2 }, {}]);
    }));
  });

  describe('removeIngredient', function () {
    beforeEach(inject(function ($controller) {
      controller = $controller('RecipeFormCtrl', { recipe: { id: 1, title: 'Test Recipe' } });
    }));

    describe('with a new ingredient', function () {
      it('removes the ingredient', function () {
        var ingredient = { quantity: '1' };
        controller.recipe.ingredients.push(ingredient);
        controller.removeIngredient(ingredient);
        expect(controller.recipe.ingredients).toEqual([{}]);
      });
    });

    describe('with a persisted ingredient', function () {
      it('marks the ingredient for destruction', function () {
        var ingredient = { id: 1, quantity: '1' };
        controller.recipe.ingredients.push(ingredient);
        controller.removeIngredient(ingredient);
        expect(controller.recipe.ingredients).toEqual([{}, { id: 1, quantity: '1', _destroy: '1' }]);
      });

      it('adds a blank ingredient when all ingredients are removed', function () {
        controller.recipe.ingredients[0].quantity = '1';
        controller.removeIngredient(controller.recipe.ingredients[0]);
        expect(controller.recipe.ingredients).toEqual([{}]);
      });
    });
  });

  describe('addIngredientAfter', function () {
    beforeEach(inject(function ($controller) {
      controller = $controller('RecipeFormCtrl', { recipe: { id: 1, title: 'Test Recipe' } });
    }));

    describe('when the ingredient is the last ingredient', function () {
      it('adds another blank ingredient', function () {
        controller.recipe.ingredients[0].quantity = '1';
        controller.addIngredientAfter(0);
        expect(controller.recipe.ingredients).toEqual([{ quantity: '1' }, {}]);
      });
    });

    describe('when the ingredient is not the last ingredient', function () {
      it('does not add an ingredient', function () {
        controller.recipe.ingredients.push({ quantity: '2' });
        controller.recipe.ingredients[0].quantity = '1';
        controller.addIngredientAfter(0);
        expect(controller.recipe.ingredients).toEqual([{ quantity: '1' }, { quantity: '2' }]);
      });
    });
  });

  describe('visibleSteps', function () {
    it('does not include steps marked for destruction', inject(function ($controller) {
      controller = $controller('RecipeFormCtrl', { recipe: { id: 1, title: 'Test Recipe', steps: [{ id: 2 }, { id: 3, _destroy: '1' }] } });
      expect(controller.visibleSteps()).toEqual([{ id: 2 }, {}]);
    }));
  });

  describe('removeStep', function () {
    beforeEach(inject(function ($controller) {
      controller = $controller('RecipeFormCtrl', { recipe: { id: 1, title: 'Test Recipe' } });
    }));

    describe('with a new step', function () {
      it('removes the step', function () {
        var step = { quantity: '1' };
        controller.recipe.steps.push(step);
        controller.removeStep(step);
        expect(controller.recipe.steps).toEqual([{}]);
      });
    });

    describe('with a persisted step', function () {
      it('marks the step for destruction', function () {
        var step = { id: 1, quantity: '1' };
        controller.recipe.steps.push(step);
        controller.removeStep(step);
        expect(controller.recipe.steps).toEqual([{}, { id: 1, quantity: '1', _destroy: '1' }]);
      });

      it('adds a blank step when all steps are removed', function () {
        controller.recipe.steps[0].description = 'Test';
        controller.removeStep(controller.recipe.steps[0]);
        expect(controller.recipe.steps).toEqual([{}]);
      });
    });
  });

  describe('addStepAfter', function () {
    beforeEach(inject(function ($controller) {
      controller = $controller('RecipeFormCtrl', { recipe: { id: 1, title: 'Test Recipe' } });
    }));

    describe('when the step is the last step', function () {
      it('adds another blank step', function () {
        controller.recipe.steps[0].description = 'Test';
        controller.addStepAfter(0);
        expect(controller.recipe.steps).toEqual([{ description: 'Test' }, {}]);
      });
    });

    describe('when the step is not the last step', function () {
      it('does not add an step', function () {
        controller.recipe.steps.push({ description: 'Other Test' });
        controller.recipe.steps[0].description = 'Test';
        controller.addStepAfter(0);
        expect(controller.recipe.steps).toEqual([{ description: 'Test' }, { description: 'Other Test' }]);
      });
    });
  });

  describe('save', function () {
    it('saves the recipe', inject(function ($controller) {
      var recipe = { id: 1, title: 'Test Recipe' };
      spyOn(recipes, 'save').andReturn(q.when({ id: 1 }));
      spyOn(location, 'path');
      controller = $controller('RecipeFormCtrl', { recipe: recipe });
      controller.save();
      expect(recipes.save).toHaveBeenCalledWith(recipe);
      rootScope.$digest();
      expect(location.path).toHaveBeenCalledWith('/recipes/1');
    }));
  });
});
