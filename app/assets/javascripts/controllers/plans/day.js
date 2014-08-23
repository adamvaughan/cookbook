/* global angular, _ */

(function () {
  'use strict';

  var app = angular.module('cookbook');

  app.controller('PlanDayCtrl', ['$routeParams', 'Plans', 'plan', 'recipes',
    function ($routeParams, Plans, plan, recipes) {
      this.day = parseInt($routeParams.day, 10);
      this.meals = _.select(plan.meals, { day: this.day });
      this.plan = plan;
      this.recipes = recipes;

      _.each(this.meals, function (meal) {
        meal.recipe = _.find(recipes, { id: meal.recipeId });
      });

      this.activateMeal = function (meal) {
        if (this.activeMeal === meal) {
          this.activeMeal = null;
        } else {
          this.activeMeal = meal;
        }
      };

      this.removeMeal = function (meal) {
        if (meal.id) {
          meal._destroy = '1';

          Plans.save(this.plan).then(_.bind(function () {
            this.plan.meals = _.without(this.plan.meals, meal);
            this.meals = _.select(this.plan.meals, { day: this.day });
          }, this));
        } else {
          this.plan.meals = _.without(this.plan.meals, meal);
          this.meals = _.select(this.plan.meals, { day: this.day });
        }
      };

      this.showRecipes = function () {
        this.recipesVisible = true;
      };

      this.hideRecipes = function () {
        this.recipesVisible = false;
      };

      this.addRecipe = function (recipe) {
        var meal = { day: this.day, recipeId: recipe.id, recipe: recipe };
        this.meals.push(meal);
        plan.meals.push(meal);

        Plans.save(plan).then(_.bind(function (plan) {
          this.plan = plan;
          this.meals = _.select(plan.meals, { day: this.day });

          _.each(this.meals, function (meal) {
            meal.recipe = _.find(recipes, { id: meal.recipeId });
          });

          this.hideRecipes();
        }, this));
      };
    }]);
})();
