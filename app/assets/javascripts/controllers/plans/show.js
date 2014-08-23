/* global angular */

(function () {
  'use strict';

  var app = angular.module('cookbook');

  app.controller('PlanCtrl', ['$location', 'Plans', 'plan',
    function ($location, Plans, plan) {
      this.plan = plan;

      this.deletePlan = function () {
        this.deletePromptVisible = true;
      };

      this.cancelDelete = function () {
        this.deletePromptVisible = false;
      };

      this.confirmDelete = function () {
        Plans.delete(this.plan).then(function () {
          $location.path('/plans');
        });
      };
    }]);
})();
