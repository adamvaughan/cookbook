/* global angular */

(function () {
  'use strict';

  var app = angular.module('cookbook');

  app.factory('Menu', function () {
    var menu = {
      show: false
    };

    menu.openMenu = function () {
      menu.show = true;
    };

    menu.closeMenu = function () {
      menu.show = false;
    };

    return menu;
  });
})();
