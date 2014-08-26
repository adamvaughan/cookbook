/* global angular */

(function () {
  'use strict';

  var app = angular.module('cookbook');

  app.factory('Scroll', ['$rootScope',
    function ($rootScope) {
      return {
        toBottom: function () {
          $rootScope.$broadcast('scrollBottom');
        }
      };
    }]);
})();
