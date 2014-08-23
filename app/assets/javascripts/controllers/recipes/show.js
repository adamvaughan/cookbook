/* global angular */

(function () {
  'use strict';

  var app = angular.module('cookbook');

  app.controller('RecipeCtrl', ['$location', 'Recipes', 'recipe',
    function ($location, Recipes, recipe) {
      this.recipe = recipe;

      this.deleteRecipe = function () {
        this.deletePromptVisible = true;
      };

      this.cancelDelete = function () {
        this.deletePromptVisible = false;
      };

      this.confirmDelete = function () {
        Recipes.delete(this.recipe).then(function () {
          $location.path('/recipes');
        });
      };
    }]);
})();
