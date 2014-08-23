/* global angular, _ */

(function () {
  'use strict';

  var app = angular.module('cookbook');

  app.factory('Recipes', ['$http', '$q',
    function ($http, $q) {
      return {
        all: function () {
          var deferred = $q.defer();

          $http.get('/recipes')
            .success(function (recipes) {
              deferred.resolve(recipes);
            })
            .error(function (data) {
              deferred.reject(data);
            });

          return deferred.promise;
        },

        get: function (recipeId) {
          var deferred = $q.defer();

          $http.get('/recipes/' + recipeId)
            .success(function (data) {
              deferred.resolve(data);
            })
            .error(function (data) {
              deferred.reject(data);
            });

          return deferred.promise;
        },

        save: function (recipe) {
          var deferred = $q.defer();
          var id = recipe.id;

          recipe = _.cloneDeep(recipe);
          delete recipe.id;
          delete recipe.createdAt;
          delete recipe.updatedAt;

          recipe.ingredients = _.reject(recipe.ingredients, function (ingredient) {
            return _.all([ingredient.quantity, ingredient.measurement, ingredient.description, ingredient.notes], function (value) {
              return _.isEmpty(value);
            });
          });

          _.each(recipe.ingredients, function (ingredient) {
            delete ingredient.createdAt;
            delete ingredient.updatedAt;
          });

          recipe.steps = _.reject(recipe.steps, function (step) {
            return _.isEmpty(step.description);
          });

          _.each(recipe.steps, function (step) {
            delete step.createdAt;
            delete step.updatedAt;
          });

          if (id) {
            $http.put('/recipes/' + id, { recipe: recipe })
              .success(function (data) {
                deferred.resolve(data);
              })
              .error(function (data) {
                deferred.reject(data);
              });
          } else {
            $http.post('/recipes', { recipe: recipe })
              .success(function (data) {
                deferred.resolve(data);
              })
              .error(function (data) {
                deferred.reject(data);
              });
          }

          return deferred.promise;
        },

        delete: function (recipe) {
          var deferred = $q.defer();

          $http.delete('/recipes/' + recipe.id)
            .success(function () {
              deferred.resolve({});
            })
            .error(function () {
              deferred.resolve({});
            });

          return deferred.promise;
        }
      };
    }]);
})();
