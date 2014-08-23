/* global angular, _ */

(function () {
  'use strict';

  var app = angular.module('cookbook');

  app.controller('RecipeListCtrl', ['recipes',
    function (recipes) {
      this.recipes = recipes;
      this.groupedRecipes = _.groupBy(recipes, function (recipe) {
        return recipe.title[0].toLowerCase();
      });
      this.letters = _.keys(this.groupedRecipes);
    }]);
})();
