/* global angular, _ */

(function () {
  'use strict';

  var app = angular.module('cookbook');

  app.controller('ListFormCtrl', ['$location', 'Lists', 'plan', 'list',
    function ($location, Lists, plan, list) {
      this.plan = plan;
      this.list = list;

      this.addItem = function () {
        this.list.items.push({
          quantity: 1,
          manuallyAdded: true
        });
      };

      this.save = function () {
        Lists.save(this.plan, this.list).then(_.bind(function () {
          $location.path('/plans/' + this.plan.id + '/list');
        }, this));
      };
    }]);
})();
