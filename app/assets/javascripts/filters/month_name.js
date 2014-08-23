/* global angular */

(function () {
  'use strict';

  var app = angular.module('cookbook');

  app.filter('monthName', function () {
    var months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

    return function (input) {
      return months[input];
    };
  });
})();
