/* global describe, beforeEach, it, expect, spyOn, inject, _ */

'use strict';

describe('Controller: PlanDayCtrl', function () {
  var controller;
  var rootScope;
  var plan;
  var plans;
  var recipes;
  var q;

  beforeEach(module('cookbook'));

  beforeEach(inject(function ($controller, $rootScope, $routeParams, $q, Plans) {
    rootScope = $rootScope;
    q = $q;
    plans = Plans;
    plan = { id: 1, month: 1, year: 2014, meals: [{ id: 1, day: 10, recipeId: 1 }, { id: 2, day: 10, recipeId: 2 }, { id: 3, day: 12, recipeId: 1 }] };
    recipes = [{ id: 1, title: 'Test Recipe 1' }, { id: 2, title: 'Test Recipe 2' }, { id: 3, title: 'Test Recipe 3' }];
    $routeParams.day = '10';
    controller = $controller('PlanDayCtrl', { plan: plan, recipes: recipes });
  }));

  describe('initialization', function () {
    it('sets the day', function () {
      expect(controller.day).toEqual(10);
    });

    it('sets the meals', function () {
      expect(controller.meals).toEqual([{ id: 1, day: 10, recipeId: 1, recipe: { id: 1, title: 'Test Recipe 1' } }, { id: 2, day: 10, recipeId: 2, recipe: { id: 2, title: 'Test Recipe 2' } }]);
    });

    it('sets the plan', function () {
      expect(controller.plan).toEqual(plan);
    });

    it('sets the recipes', function () {
      expect(controller.recipes).toEqual(recipes);
    });
  });

  describe('activateMeal', function () {
    var meal = { id: 1, day: 1 };

    it('sets the active meal', function () {
      controller.activeMeal = null;
      controller.activateMeal(meal);
      expect(controller.activeMeal).toEqual(meal);
    });

    describe('when the meal is already active', function () {
      it('unsets the active meal', function () {
        controller.activeMeal = meal;
        controller.activateMeal(meal);
        expect(controller.activeMeal).toBeNull();
      });
    });
  });

  describe('removeMeal', function () {
    describe('with a new meal', function () {
      it('removes the meal', function () {
        var meal = { day: 10, recipeId: 3 };
        controller.plan.meals.push(meal);
        controller.meals.push(meal);
        controller.removeMeal(meal);
        expect(controller.plan.meals).toEqual([{ id: 1, day: 10, recipeId: 1, recipe: { id: 1, title: 'Test Recipe 1' } }, { id: 2, day: 10, recipeId: 2, recipe: { id: 2, title: 'Test Recipe 2' } }, { id: 3, day: 12, recipeId: 1 }]);
        expect(controller.meals).toEqual([{ id: 1, day: 10, recipeId: 1, recipe: { id: 1, title: 'Test Recipe 1' } }, { id: 2, day: 10, recipeId: 2, recipe: { id: 2, title: 'Test Recipe 2' } }]);
      });
    });

    describe('with a persisted meal', function () {
      it('deletes the meal', function () {
        var meal = { id: 4, day: 10, recipeId: 3 };
        controller.plan.meals.push(meal);
        controller.meals.push(meal);

        spyOn(plans, 'save').andReturn(q.when([]));

        controller.removeMeal(meal);
        expect(controller.plan.meals).toEqual([{ id: 1, day: 10, recipeId: 1, recipe: { id: 1, title: 'Test Recipe 1' } }, { id: 2, day: 10, recipeId: 2, recipe: { id: 2, title: 'Test Recipe 2' } }, { id: 3, day: 12, recipeId: 1 }, { id: 4, day: 10, recipeId: 3, _destroy: '1' }]);
        expect(controller.meals).toEqual([{ id: 1, day: 10, recipeId: 1, recipe: { id: 1, title: 'Test Recipe 1' } }, { id: 2, day: 10, recipeId: 2, recipe: { id: 2, title: 'Test Recipe 2' } }, { id: 4, day: 10, recipeId: 3, _destroy: '1' }]);

        rootScope.$apply();
        expect(controller.plan.meals).toEqual([{ id: 1, day: 10, recipeId: 1, recipe: { id: 1, title: 'Test Recipe 1' } }, { id: 2, day: 10, recipeId: 2, recipe: { id: 2, title: 'Test Recipe 2' } }, { id: 3, day: 12, recipeId: 1 }]);
        expect(controller.meals).toEqual([{ id: 1, day: 10, recipeId: 1, recipe: { id: 1, title: 'Test Recipe 1' } }, { id: 2, day: 10, recipeId: 2, recipe: { id: 2, title: 'Test Recipe 2' } }]);
      });
    });
  });

  describe('showRecipes', function () {
    it('shows the recipes dialog', function () {
      controller.recipesVisible = false;
      controller.showRecipes();
      expect(controller.recipesVisible).toBeTruthy();
    });
  });

  describe('hideRecipes', function () {
    it('hides the recipes dialog', function () {
      controller.recipesVisible = true;
      controller.hideRecipes();
      expect(controller.recipesVisible).toBeFalsy();
    });
  });

  describe('addRecipe', function () {
    it('adds the recipe to the plan', function () {
      var recipe = _.find(recipes, { id: 3 });

      spyOn(plans, 'save').andReturn(q.when({ id: 1, month: 1, year: 2014, meals: [{ id: 1, day: 10, recipeId: 1 }, { id: 2, day: 10, recipeId: 2 }, { id: 3, day: 12, recipeId: 1 }, { id: 4, day: 10, recipeId: 3 }] }));

      controller.addRecipe(recipe);
      expect(controller.plan.meals).toEqual([{ id: 1, day: 10, recipeId: 1, recipe: { id: 1, title: 'Test Recipe 1' } }, { id: 2, day: 10, recipeId: 2, recipe: { id: 2, title: 'Test Recipe 2' } }, { id: 3, day: 12, recipeId: 1 }, { day: 10, recipeId: 3, recipe: recipe }]);
      expect(controller.meals).toEqual([{ id: 1, day: 10, recipeId: 1, recipe: { id: 1, title: 'Test Recipe 1' } }, { id: 2, day: 10, recipeId: 2, recipe: { id: 2, title: 'Test Recipe 2' } }, { day: 10, recipeId: 3, recipe: recipe }]);

      rootScope.$apply();
      expect(controller.plan).toEqual({ id: 1, month: 1, year: 2014, meals: [{ id: 1, day: 10, recipeId: 1, recipe: { id: 1, title: 'Test Recipe 1' } }, { id: 2, day: 10, recipeId: 2, recipe: { id: 2, title: 'Test Recipe 2' } }, { id: 3, day: 12, recipeId: 1 }, { id: 4, day: 10, recipeId: 3, recipe: recipe }] });
      expect(controller.meals).toEqual([{ id: 1, day: 10, recipeId: 1, recipe: { id: 1, title: 'Test Recipe 1' } }, { id: 2, day: 10, recipeId: 2, recipe: { id: 2, title: 'Test Recipe 2' } }, { id: 4, day: 10, recipeId: 3, recipe: recipe }]);
    });
  });
});
