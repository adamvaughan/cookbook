/* global angular, FastClick */

//= require angular/angular
//= require angular-route/angular-route
//= require lodash/lodash
//= require fastclick/lib/fastclick
//= require_self
//= require_tree .

(function () {
  'use strict';

  var app = angular.module('cookbook', ['ngRoute']);

  app.config(['$routeProvider', '$locationProvider',
    function ($routeProvider, $locationProvider) {
      $locationProvider.html5Mode(true);

      $routeProvider
        .when('/', {
          templateUrl: '/views/partials/recipes/list.html',
          controller: 'RecipeListCtrl as main',
          resolve: {
            recipes: ['Recipes',
              function (Recipes) {
                return Recipes.all();
              }]
          }
        })
        .when('/recipes/new', {
          templateUrl: '/views/partials/recipes/new.html',
          controller: 'RecipeFormCtrl as main',
          resolve: {
            recipe: ['$q',
              function ($q) {
                return $q.when({});
              }]
          }
        })
        .when('/recipes/:recipeId', {
          templateUrl: '/views/partials/recipes/show.html',
          controller: 'RecipeCtrl as main',
          resolve: {
            recipe: ['$route', 'Recipes',
              function ($route, Recipes) {
                return Recipes.get($route.current.params.recipeId);
              }]
          }
        })
        .when('/recipes/:recipeId/edit', {
          templateUrl: '/views/partials/recipes/edit.html',
          controller: 'RecipeFormCtrl as main',
          resolve: {
            recipe: ['$route', 'Recipes',
              function ($route, Recipes) {
                return Recipes.get($route.current.params.recipeId);
              }]
          }
        })
        .when('/plans', {
          templateUrl: '/views/partials/plans/list.html',
          controller: 'PlanListCtrl as main',
          resolve: {
            plans: ['Plans',
              function (Plans) {
                return Plans.all();
              }]
          }
        })
        .when('/plans/new', {
          templateUrl: '/views/partials/plans/new.html',
          controller: 'PlanFormCtrl as main',
          resolve: {
            plan: ['$q',
              function ($q) {
                return $q.when({});
              }]
          }
        })
        .when('/plans/:planId', {
          templateUrl: '/views/partials/plans/show.html',
          controller: 'PlanCtrl as main',
          resolve: {
            plan: ['$route', 'Plans',
              function ($route, Plans) {
                return Plans.get($route.current.params.planId);
              }]
          }
        })
        .when('/plans/:planId/edit', {
          templateUrl: '/views/partials/plans/edit.html',
          controller: 'PlanFormCtrl as main',
          resolve: {
            plan: ['$route', 'Plans',
              function ($route, Plans) {
                return Plans.get($route.current.params.planId);
              }]
          }
        })
        .when('/plans/:planId/day/:day', {
          templateUrl: '/views/partials/plans/day.html',
          controller: 'PlanDayCtrl as main',
          resolve: {
            plan: ['$route', 'Plans',
              function ($route, Plans) {
                return Plans.get($route.current.params.planId);
              }],
            recipes: ['Recipes',
              function (Recipes) {
                return Recipes.all();
              }]
          }
        })
        .when('/plans/:planId/list', {
          templateUrl: '/views/partials/lists/show.html',
          controller: 'ListCtrl as main',
          resolve: {
            plan: ['$route', 'Plans',
              function ($route, Plans) {
                return Plans.get($route.current.params.planId);
              }],
            list: ['$route', 'Lists',
              function ($route, Lists) {
                return Lists.get($route.current.params.planId);
              }]
          }
        })
        .when('/plans/:planId/list/edit', {
          templateUrl: '/views/partials/lists/edit.html',
          controller: 'ListFormCtrl as main',
          resolve: {
            plan: ['$route', 'Plans',
              function ($route, Plans) {
                return Plans.get($route.current.params.planId);
              }],
            list: ['$route', 'Lists',
              function ($route, Lists) {
                return Lists.get($route.current.params.planId);
              }]
          }
        })
        .otherwise({
          redirectTo: '/'
        });
    }]);

  app.run(['$http',
    function ($http) {
      $http.defaults.headers.common.Accept = 'application/json';
    }]);

  window.addEventListener('load', function () {
    FastClick.attach(document.body);
  }, false);
})();
