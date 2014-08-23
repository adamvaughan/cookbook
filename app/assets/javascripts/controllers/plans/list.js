/* global angular, _ */

(function () {
  'use strict';

  var app = angular.module('cookbook');

  app.controller('PlanListCtrl', ['plans',
    function (plans) {
      this.plans = plans;
      this.groupedPlans = _.groupBy(plans, 'year');
      this.years = _.keys(this.groupedPlans);
      this.identity = angular.identity;
    }]);
})();
