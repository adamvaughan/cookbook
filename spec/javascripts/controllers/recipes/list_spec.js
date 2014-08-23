/* global describe, beforeEach, it, expect, inject */

'use strict';

describe('Controller: RecipeListCtrl', function () {
  var controller;
  var recipes;

  beforeEach(module('cookbook'));

  beforeEach(inject(function ($controller) {
    recipes = [{ id: 1, title: 'Apples' }, { id: 2, title: 'Bananas' }];
    controller = $controller('RecipeListCtrl', { recipes: recipes });
  }));

  describe('initialization', function () {
    it('sets the recipes', function () {
      expect(controller.recipes).toEqual(recipes);
      expect(controller.groupedRecipes).toEqual({ a: [{ id: 1, title: 'Apples' }], b: [{ id: 2, title: 'Bananas' }] });
      expect(controller.letters).toEqual(['a', 'b']);
    });
  });
});
