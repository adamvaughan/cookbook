/* global angular, _ */

(function () {
  'use strict';

  var app = angular.module('cookbook');

  app.directive('calendar', function () {
    return {
      scope: {
        plan: '=calendar'
      },
      templateUrl: '/views/partials/plans/calendar.html',
      link: function (scope, element) {
        var startingDayOfMonth = new Date(scope.plan.year, scope.plan.month, 1).getDay();
        var daysInMonth = new Date(scope.plan.year, scope.plan.month + 1, 0).getDate();
        var weekCount = (startingDayOfMonth + daysInMonth) / 7;
        var meals = _.groupBy(scope.plan.meals, 'day');
        var day;
        var i;
        var j;

        scope.weeks = [];

        for (i = 0; i < weekCount; i++) {
          scope.weeks.push({ days: [] });

          for (j = 1; j < 8; j++) {
            day = i * 7 + j - startingDayOfMonth;

            if (day <= daysInMonth) {
              scope.weeks[i].days.push({
                number: day,
                meals: meals[day]
              });
            }
          }
        }

        element.addClass('calendar');
      }
    };
  });
})();
