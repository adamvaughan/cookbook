/* global angular, _ */

(function () {
  'use strict';

  var app = angular.module('cookbook');

  app.controller('RecipeFormCtrl', ['$location', 'Recipes', 'recipe',
    function ($location, Recipes, recipe) {
      if (!recipe.ingredients) {
        recipe.ingredients = [];
      }

      if (!recipe.steps) {
        recipe.steps = [];
      }

      this.recipe = recipe;
      this.recipe.ingredients.push({});
      this.recipe.steps.push({});

      this.visibleIngredients = function () {
        return _.reject(this.recipe.ingredients, { _destroy: '1' });
      };

      this.removeIngredient = function (ingredient) {
        if (ingredient.id) {
          ingredient._destroy = '1';
        } else {
          this.recipe.ingredients = _.without(this.recipe.ingredients, ingredient);
        }

        if (this.visibleIngredients().length === 0) {
          this.recipe.ingredients.push({});
        }
      };

      this.addIngredientAfter = function (index) {
        // only add an ingredient after the last ingredient
        if (index === this.visibleIngredients().length - 1) {
          this.recipe.ingredients.push({});
        }
      };

      this.visibleSteps = function () {
        return _.reject(this.recipe.steps, { _destroy: '1' });
      };

      this.removeStep = function (step) {
        if (step.id) {
          step._destroy = '1';
        } else {
          this.recipe.steps = _.without(this.recipe.steps, step);
        }

        if (this.visibleSteps().length === 0) {
          this.recipe.steps.push({});
        }
      };

      this.addStepAfter = function (index) {
        // only add a step after the last step
        if (index === this.visibleSteps().length - 1) {
          this.recipe.steps.push({});
        }
      };

      this.save = function () {
        Recipes.save(this.recipe).then(function (recipe) {
          $location.path('/recipes/' + recipe.id);
        });
      };
    }]);
})();
