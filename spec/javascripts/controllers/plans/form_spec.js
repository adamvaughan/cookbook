/* global describe, beforeEach, it, expect, spyOn, inject */

'use strict';

describe('Controller: PlanFormCtrl', function () {
  var controller;
  var rootScope;
  var plan;
  var plans;
  var location;
  var q;

  beforeEach(module('cookbook'));

  beforeEach(inject(function ($controller, $rootScope, $location, $q, Plans) {
    rootScope = $rootScope;
    location = $location;
    q = $q;
    plans = Plans;
    plan = { month: 8, year: 2014 };
    controller = $controller('PlanFormCtrl', { plan: plan });
  }));

  describe('initialization', function () {
    it('sets the plan', function () {
      expect(controller.plan).toEqual(plan);
    });
  });

  describe('showMonths', function () {
    it('hides the years dialog', function () {
      controller.yearsVisible = true;
      controller.showMonths();
      expect(controller.yearsVisible).toBeFalsy();
    });

    it('shows the months dialog', function () {
      controller.monthsVisible = false;
      controller.showMonths();
      expect(controller.monthsVisible).toBeTruthy();
    });
  });

  describe('hideMonths', function () {
    it('hides the months dialog', function () {
      controller.monthsVisible = true;
      controller.hideMonths();
      expect(controller.monthsVisible).toBeFalsy();
    });
  });

  describe('showYears', function () {
    it('hides the months dialog', function () {
      controller.monthsVisible = true;
      controller.showYears();
      expect(controller.monthsVisible).toBeFalsy();
    });

    it('shows the years dialog', function () {
      controller.yearsVisible = false;
      controller.showYears();
      expect(controller.yearsVisible).toBeTruthy();
    });
  });

  describe('hideYears', function () {
    it('hides the years dialog', function () {
      controller.yearsVisible = true;
      controller.hideYears();
      expect(controller.yearsVisible).toBeFalsy();
    });
  });

  describe('chooseMonth', function () {
    it('sets the month', function () {
      controller.chooseMonth(1);
      expect(controller.plan.month).toEqual(1);
    });

    it('hides the months dialog', function () {
      controller.monthsVisible = true;
      controller.chooseMonth(1);
      expect(controller.monthsVisible).toBeFalsy();
    });
  });

  describe('chooseYear', function () {
    it('sets the year', function () {
      controller.chooseYear(2015);
      expect(controller.plan.year).toEqual(2015);
    });

    it('hides the years dialog', function () {
      controller.yearsVisible = true;
      controller.chooseYear(2015);
      expect(controller.yearsVisible).toBeFalsy();
    });
  });

  describe('save', function () {
    it('saves the plan', function () {
      spyOn(plans, 'save').andReturn(q.when({ id: 1 }));
      spyOn(location, 'path');

      controller.save();
      expect(plans.save).toHaveBeenCalledWith(plan);

      rootScope.$apply();
      expect(location.path).toHaveBeenCalledWith('/plans/1');
    });
  });
});
