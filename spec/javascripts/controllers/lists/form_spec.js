/* global describe, beforeEach, it, expect, spyOn, inject */

'use strict';

describe('Controller: ListFormCtrl', function () {
  var controller;
  var plan;
  var list;
  var lists;
  var location;
  var rootScope;
  var q;

  beforeEach(module('cookbook'));

  beforeEach(inject(function ($controller, $rootScope, $location, $q, Lists) {
    plan = { id: 1, month: 8, year: 2014 };
    list = { id: 2, items: [] };
    lists = Lists;
    rootScope = $rootScope;
    location = $location;
    q = $q;
    controller = $controller('ListFormCtrl', { plan: plan, list: list });
  }));

  describe('initialization', function () {
    it('sets the plan', function () {
      expect(controller.plan).toEqual(plan);
    });

    it('sets the list', function () {
      expect(controller.list).toEqual(list);
    });
  });

  describe('addItem', function () {
    it('adds a new item', function () {
      controller.addItem();
      expect(controller.list.items).toEqual([{ quantity: 1, manuallyAdded: true }]);
    });
  });

  describe('save', function () {
    it('saves the list', function () {
      spyOn(lists, 'save').andReturn(q.when([]));
      spyOn(location, 'path');

      controller.save();
      expect(lists.save).toHaveBeenCalledWith(plan, list);

      rootScope.$apply();
      expect(location.path).toHaveBeenCalledWith('/plans/1/list');
    });
  });
});
