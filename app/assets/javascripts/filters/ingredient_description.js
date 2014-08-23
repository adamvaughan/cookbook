/* global angular, _ */

(function () {
  'use strict';

  var app = angular.module('cookbook');

  app.filter('ingredientDescription', function () {
    return function (ingredient) {
      var result = _.compact([ingredient.measurement, ingredient.description]).join(' ');

      if (ingredient.notes) {
        result += [',', ingredient.notes].join(' ');
      }

      return result;
    };
  });
})();
