/* global angular, _ */

(function () {
  'use strict';

  var app = angular.module('cookbook');

  app.factory('Plans', ['$http', '$q',
    function ($http, $q) {
      return {
        all: function () {
          var deferred = $q.defer();

          $http.get('/plans')
            .success(function (recipes) {
              deferred.resolve(recipes);
            })
            .error(function (data) {
              deferred.reject(data);
            });

          return deferred.promise;
        },

        get: function (planId) {
          var deferred = $q.defer();

          $http.get('/plans/' + planId)
            .success(function (data) {
              deferred.resolve(data);
            })
            .error(function (data) {
              deferred.reject(data);
            });

          return deferred.promise;
        },

        save: function (plan) {
          var deferred = $q.defer();
          var id = plan.id;

          plan = _.cloneDeep(plan);
          delete plan.id;
          delete plan.createdAt;
          delete plan.updatedAt;

          _.each(plan.meals, function (meal) {
            delete meal.recipe;
            delete meal.createdAt;
            delete meal.updatedAt;
          });

          if (id) {
            $http.put('/plans/' + id, { plan: plan })
              .success(function (data) {
                deferred.resolve(data);
              })
              .error(function (data) {
                deferred.reject(data);
              });
          } else {
            $http.post('/plans', { plan: plan })
              .success(function (data) {
                deferred.resolve(data);
              })
              .error(function (data) {
                deferred.reject(data);
              });
          }

          return deferred.promise;
        },

        delete: function (plan) {
          var deferred = $q.defer();

          $http.delete('/plans/' + plan.id)
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
