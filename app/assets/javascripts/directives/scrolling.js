/* global angular */

(function () {
  'use strict';

  var app = angular.module('cookbook');

  app.directive('scrolling', function () {
    return {
      restrict: 'A',
      link: function (scope, element) {
        scope.$on('scrollBottom', function () {
          var el = element[0];
          el.scrollTop = el.scrollHeight;
        });
      }
    };
  });
})();
