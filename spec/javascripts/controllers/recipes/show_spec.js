/* global describe, beforeEach, it, expect, spyOn, inject */

'use strict';

describe('Controller: RecipeCtrl', function () {
  var controller;
  var rootScope;
  var location;
  var q;
  var recipes;
  var recipe;

  beforeEach(module('cookbook'));

  beforeEach(inject(function ($controller, $rootScope, $location, $q, Recipes) {
    rootScope = $rootScope;
    location = $location;
    q = $q;
    recipes = Recipes;
    recipe = { id: 1, title: 'Test Recipe' };

    controller = $controller('RecipeCtrl', { recipe: recipe });
  }));

  describe('initialization', function () {
    it('sets the recipe', function () {
      expect(controller.recipe).toEqual(recipe);
    });
  });

  describe('deleteRecipe', function () {
    it('prompts for confirmation', function () {
      controller.deletePromptVisible = false;
      controller.deleteRecipe();
      expect(controller.deletePromptVisible).toBeTruthy();
    });
  });

  describe('cancelDelete', function () {
    it('hides the confirmation prompt', function () {
      controller.deletePromptVisible = true;
      controller.cancelDelete();
      expect(controller.deletePromptVisible).toBeFalsy();
    });
  });

  describe('confirmDelete', function () {
    it('deletes the recipe', function () {
      spyOn(recipes, 'delete').andReturn(q.when({}));
      spyOn(location, 'path');
      controller.confirmDelete();
      expect(recipes.delete).toHaveBeenCalledWith(recipe);
      rootScope.$digest();
      expect(location.path).toHaveBeenCalledWith('/recipes');
    });
  });
});
