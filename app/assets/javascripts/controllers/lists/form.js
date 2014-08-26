/* global angular, _ */

(function () {
  'use strict';

  var app = angular.module('cookbook');

  app.controller('ListFormCtrl', ['$location', 'Scroll', 'Lists', 'plan', 'list',
    function ($location, Scroll, Lists, plan, list) {
      this.plan = plan;
      this.list = list;

      this.visibleItems = function () {
        return _.reject(this.list.items, { _destroy: '1' });
      };

      this.addItem = function () {
        this.list.items.push({
          quantity: 1,
          manuallyAdded: true
        });

        Scroll.toBottom();
      };

      this.activateItem = function (item) {
        this.activeItem = item;
      };

      this.removeItem = function (item) {
        if (item.id) {
          item._destroy = '1';
        } else {
          this.list.items = _.without(this.list.items, item);
        }
      };

      this.save = function () {
        Lists.save(this.plan, this.list).then(_.bind(function () {
          $location.path('/plans/' + this.plan.id + '/list');
        }, this));
      };
    }]);
})();
