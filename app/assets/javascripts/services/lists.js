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
