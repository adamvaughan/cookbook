/* global describe, beforeEach, afterEach, it, expect, inject */

'use strict';

describe('Service: Plans', function () {
  var service;
  var httpBackend;

  beforeEach(module('cookbook'));

  beforeEach(inject(function (Plans, $httpBackend) {
    service = Plans;
    httpBackend = $httpBackend;
  }));

  afterEach(function() {
    httpBackend.verifyNoOutstandingExpectation();
    httpBackend.verifyNoOutstandingRequest();
  });

  describe('all', function () {
    it('returns all plans', function () {
      httpBackend.expectGET('/plans').respond([{ id: 1 }, { id: 2 }]);

      service.all().then(function (plans) {
        expect(plans).toEqual([{ id: 1 }, { id: 2 }]);
      });

      httpBackend.flush();
    });
  });

  describe('get', function () {
    it('returns the plan', function () {
      httpBackend.expectGET('/plans/1').respond({ id: 1 });

      service.get(1).then(function (plan) {
        expect(plan).toEqual({ id: 1 });
      });

      httpBackend.flush();
    });
  });

  describe('save', function () {
    it('saves a new plan', function () {
      httpBackend.expectPOST('/plans', { plan: { month: 1, year: 2014, meals: [{ day: 1, recipeId: 1 }] } }).respond({ id: 1 });

      service.save({
        month: 1,
        year: 2014,
        meals: [{
          day: 1,
          recipeId: 1,
          recipe: {
            id: 1
          }
        }]
      }).then(function (plan) {
        expect(plan).toEqual({ id: 1 });
      });

      httpBackend.flush();
    });

    it('updates an existing plan', function () {
      httpBackend.expectPUT('/plans/1', { plan: { month: 1, year: 2014, meals: [{ id: 2, recipeId: 1 }] } }).respond({ id: 1 });

      service.save({
        id: 1,
        month: 1,
        year: 2014,
        createdAt: '2014-08-26',
        updatedAt: '2014-08-26',
        meals: [{
          id: 2,
          recipeId: 1,
          recipe: {
            id: 1
          },
          createdAt: '2014-08-26',
          updatedAt: '2014-08-26'
        }]
      }).then(function (plan) {
        expect(plan).toEqual({ id: 1 });
      });

      httpBackend.flush();
    });
  });

  describe('delete', function () {
    it('deletes the plan', function () {
      httpBackend.expectDELETE('/plans/1').respond(204);
      service.delete({ id: 1 });
      httpBackend.flush();
    });
  });
});
