/* global describe, beforeEach, afterEach, it, expect, inject */

'use strict';

describe('Service: Lists', function () {
  var service;
  var httpBackend;

  beforeEach(module('cookbook'));

  beforeEach(inject(function ($httpBackend, Lists) {
    service = Lists;
    httpBackend = $httpBackend;
  }));

  afterEach(function() {
    httpBackend.verifyNoOutstandingExpectation();
    httpBackend.verifyNoOutstandingRequest();
  });

  describe('get', function () {
    it('returns the list for a plan', function () {
      httpBackend.expectGET('/plans/1/list').respond({ id: 2, items: [{ id: 3, quantity: '1.0' }] });

      service.get(1).then(function (list) {
        expect(list).toEqual({ id: 2, items: [{ id: 3, quantity: 1.0 }] });
      });

      httpBackend.flush();
    });
  });

  describe('save', function () {
    it('saves the list for a plan', function () {
      httpBackend.expectPUT('/plans/1/list', {
        list: {
          items: [{
            id: 3,
            quantity: '1',
            measurement: 'cup',
            description: 'milk',
            purchased: true
          }]
        }
      }).respond({ id: 2 });

      service.save({ id: 1 }, {
        id: 2,
        planId: 1,
        createdAt: '2014-08-26',
        updatedAt: '2014-08-26',
        items: [{
          id: 3,
          quantity: '1',
          measurement: 'cup',
          description: 'milk',
          purchased: true,
          createdAt: '2014-08-26',
          updatedAt: '2014-08-26'
        }]
      }).then(function (list) {
        expect(list).toEqual({ id: 2 });
      });

      httpBackend.flush();
    });
  });

  describe('delete', function () {
    it('deletes the list for a plan', function () {
      httpBackend.expectDELETE('/plans/1/list').respond(204);
      service.delete({ id: 1 });
      httpBackend.flush();
    });
  });
});
