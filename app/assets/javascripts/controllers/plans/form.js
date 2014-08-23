/* global angular, _ */

(function () {
  'use strict';

  var app = angular.module('cookbook');

  app.controller('PlanFormCtrl', ['$location', 'Plans', 'plan',
    function ($location, Plans, plan) {
      var today = new Date();

      if (!plan.year) {
        plan.year = today.getFullYear();
        plan.month = today.getMonth();
      }

      this.plan = plan;
      this.years = _.map([-1, 0, 1, 2], function (i) {
        return today.getFullYear() - i;
      });

      this.showMonths = function () {
        this.hideYears();
        this.monthsVisible = true;
      };

      this.hideMonths = function () {
        this.monthsVisible = false;
      };

      this.showYears = function () {
        this.hideMonths();
        this.yearsVisible = true;
      };

      this.hideYears = function () {
        this.yearsVisible = false;
      };

      this.chooseMonth = function (month) {
        this.plan.month = month;
        this.hideMonths();
      };

      this.chooseYear = function (year) {
        this.plan.year = year;
        this.hideYears();
      };

      this.save = function () {
        Plans.save(this.plan).then(function (plan) {
          $location.path('/plans/' + plan.id);
        });
      };
    }]);
})();
