/* global describe, beforeEach, afterEach, it, expect, inject */

'use strict';

describe('Service: Recipes', function () {
  var service;
  var httpBackend;

  beforeEach(module('cookbook'));

  beforeEach(inject(function ($httpBackend, Recipes) {
    service = Recipes;
    httpBackend = $httpBackend;
  }));

  afterEach(function() {
    httpBackend.verifyNoOutstandingExpectation();
    httpBackend.verifyNoOutstandingRequest();
  });

  describe('all', function () {
    it('returns all recipes', function () {
      httpBackend.expectGET('/recipes').respond([{ id: 1 }, { id: 2 }]);

      service.all().then(function (recipes) {
        expect(recipes).toEqual([{ id: 1 }, { id: 2 }]);
      });

      httpBackend.flush();
    });
  });

  describe('get', function () {
    it('returns the recipe', function () {
      httpBackend.expectGET('/recipes/1').respond({ id: 1 });

      service.get(1).then(function (recipe) {
        expect(recipe).toEqual({ id: 1 });
      });

      httpBackend.flush();
    });
  });

  describe('save', function () {
    it('saves a new recipe', function () {
      httpBackend.expectPOST('/recipes', { recipe: { title: 'Test', notes: 'Testing', ingredients: [{ index: 1, quantity: '1', measurement: 'cup', description: 'milk' }], steps: [{ index: 1, description: 'Cook' }] } }).respond({ id: 1 });

      service.save({
        title: 'Test',
        notes: 'Testing',
        ingredients: [{
          index: 1,
          quantity: '1',
          measurement: 'cup',
          description: 'milk'
        }],
        steps: [{
          index: 1,
          description: 'Cook'
        }]
      }).then(function (recipe) {
        expect(recipe).toEqual({ id: 1 });
      });

      httpBackend.flush();
    });

    it('updates an existing recipe', function () {
      httpBackend.expectPUT('/recipes/1', { recipe: { title: 'Test', notes: 'Testing', ingredients: [{ id: 1, index: 1, quantity: '1', measurement: 'cup', description: 'milk' }], steps: [{ id: 2, index: 1, description: 'Cook' }] } }).respond({ id: 1 });

      service.save({
        id: 1,
        title: 'Test',
        notes: 'Testing',
        createdAt: '2014-08-26',
        updatedAt: '2014-08-26',
        ingredients: [{
          id: 1,
          index: 1,
          quantity: '1',
          measurement: 'cup',
          description: 'milk',
          createdAt: '2014-08-26',
          updatedAt: '2014-08-26'
        }],
        steps: [{
          id: 2,
          index: 1,
          description: 'Cook',
          createdAt: '2014-08-26',
          updatedAt: '2014-08-26',
        }]
      }).then(function (recipe) {
        expect(recipe).toEqual({ id: 1 });
      });

      httpBackend.flush();
    });
  });

  describe('delete', function () {
    it('deletes the recipe', function () {
      httpBackend.expectDELETE('/recipes/1').respond(204);
      service.delete({ id: 1 });
      httpBackend.flush();
    });
  });
});
