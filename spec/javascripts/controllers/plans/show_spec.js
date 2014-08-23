/* global describe, beforeEach, it, expect, spyOn, inject */

'use strict';

describe('Controller: PlanCtrl', function () {
  var controller;
  var plan;
  var plans;
  var location;
  var rootScope;
  var q;

  beforeEach(module('cookbook'));

  beforeEach(inject(function ($controller, $rootScope, $location, $q, Plans) {
    rootScope = $rootScope;
    location = $location;
    q = $q;
    plans = Plans;
    plan = { id: 1, month: 8, year: 2014 };
    controller = $controller('PlanCtrl', { plan: plan });
  }));

  describe('initialization', function () {
    it('sets the plan', function () {
      expect(controller.plan).toEqual(plan);
    });
  });

  describe('deletePlan', function () {
    it('shows the confirmation dialog', function () {
      controller.deletePromptVisible = false;
      controller.deletePlan();
      expect(controller.deletePromptVisible).toBeTruthy();
    });
  });

  describe('cancelDelete', function () {
    it('hides the confirmation dialog', function () {
      controller.deletePromptVisible = true;
      controller.cancelDelete();
      expect(controller.deletePromptVisible).toBeFalsy();
    });
  });

  describe('confirmDelete', function () {
    it('deletes the plan', function () {
      spyOn(plans, 'delete').andReturn(q.when([]));
      spyOn(location, 'path');

      controller.confirmDelete();
      expect(plans.delete).toHaveBeenCalledWith(plan);

      rootScope.$apply();
      expect(location.path).toHaveBeenCalledWith('/plans');
    });
  });
});
