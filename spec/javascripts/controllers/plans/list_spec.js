/* global describe, beforeEach, it, expect, inject */

'use strict';

describe('Controller: PlanListCtrl', function () {
  var controller;
  var plans;

  beforeEach(module('cookbook'));

  beforeEach(inject(function ($controller) {
    plans = [{ id: 1, month: 7, year: 2013 }, { id: 2, month: 6, year: 2013 }, { id: 3, month: 8, year: 2014 }];
    controller = $controller('PlanListCtrl', { plans: plans });
  }));

  describe('initialization', function () {
    it('sets the plans', function () {
      expect(controller.plans).toEqual(plans);
      expect(controller.groupedPlans).toEqual({ 2013: [{ id: 1, month: 7, year: 2013 }, { id: 2, month: 6, year: 2013 }], 2014: [{ id: 3, month: 8, year: 2014 }] });
      expect(controller.years).toEqual(['2013', '2014']);
    });
  });
});
