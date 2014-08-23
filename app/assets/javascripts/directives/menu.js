/* global angular */

(function () {
  'use strict';

  var app = angular.module('cookbook');

  app.directive('menu', function () {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: '/views/partials/menu.html',
      controller: ['Menu', function (Menu) {
        this.show = function () {
          return Menu.show;
        };

        this.closeMenu = function () {
          Menu.closeMenu();
        };
      }],
      controllerAs: 'menu'
    };
  });
})();
