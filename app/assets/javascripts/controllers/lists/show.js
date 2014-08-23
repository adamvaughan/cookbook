/* global angular, _ */

(function () {
  'use strict';

  var app = angular.module('cookbook');

  app.controller('ListCtrl', ['$location', 'Lists', 'plan', 'list',
    function ($location, Lists, plan, list) {
      this.plan = plan;
      this.list = list;

      this.deleteList = function () {
        this.deletePromptVisible = true;
      };

      this.cancelDelete = function () {
        this.deletePromptVisible = false;
      };

      this.confirmDelete = function () {
        Lists.delete(this.plan).then(_.bind(function () {
          $location.path('/plans/' + this.plan.id);
        }, this));
      };

      this.regenerateShoppingList = function () {
        var controller = this;
        var plan = this.plan;

        this.list.items = [];

        Lists.delete(plan).then(function () {
          Lists.get(plan.id).then(function (list) {
            controller.list = list;
          });
        });
      };

      this.saveList = function () {
        Lists.save(this.plan, this.list);
      };
    }]);
})();
