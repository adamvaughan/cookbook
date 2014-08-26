/* global angular, _ */

(function () {
  'use strict';

  var app = angular.module('cookbook');

  app.factory('Lists', ['$http', '$q',
    function ($http, $q) {
      return {
        get: function (planId) {
          var deferred = $q.defer();

          $http.get('/plans/' + planId + '/list')
            .success(function (data) {
              _.each(data.items, function (item) {
                item.quantity = parseFloat(item.quantity);
              });
              deferred.resolve(data);
            })
            .error(function (data) {
              deferred.reject(data);
            });

          return deferred.promise;
        },

        save: function (plan, list) {
          var deferred = $q.defer();

          list = _.cloneDeep(list);
          delete list.id;
          delete list.planId;
          delete list.createdAt;
          delete list.updatedAt;

          _.each(list.items, function (item) {
            delete item.createdAt;
            delete item.updatedAt;
          });

          $http.put('/plans/' + plan.id + '/list', { list: list })
            .success(function (data) {
              deferred.resolve(data);
            })
            .error(function (data) {
              deferred.reject(data);
            });

          return deferred.promise;
        },

        delete: function (plan) {
          var deferred = $q.defer();

          $http.delete('/plans/' + plan.id + '/list')
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
