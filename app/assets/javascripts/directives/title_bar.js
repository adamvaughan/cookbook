/* global angular, _ */

(function () {
  'use strict';

  var app = angular.module('cookbook');

  app.directive('titleBar', function () {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: '/views/partials/title_bar.html',
      controller: ['$attrs', 'Menu', function ($attrs, Menu) {
        $attrs.$observe('backPath', _.bind(function (value) {
          this.backPath = value;
        }, this));

        this.openMenu = function () {
          Menu.openMenu();
        };
      }],
      controllerAs: 'titleBar'
    };
  });
})();
