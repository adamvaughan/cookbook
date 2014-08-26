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

  describe('visibleItems', function () {
    it('does not include items marked for destruction', function () {
      list.items.push({ id: 1, quantity: 1, description: 'Test 1' });
      list.items.push({ id: 2, quantity: 2, description: 'Test 2', _destroy: '1' });
      expect(controller.visibleItems()).toEqual([{ id: 1, quantity: 1, description: 'Test 1' }]);
    });
  });

  describe('addItem', function () {
    it('adds a new item', function () {
      controller.addItem();
      expect(controller.list.items).toEqual([{ quantity: 1, manuallyAdded: true }]);
    });
  });

  describe('activateItem', function () {
    it('sets the active item', function () {
      var item = { id: 1 };
      controller.activateItem(item);
      expect(controller.activeItem).toEqual(item);
    });
  });

  describe('removeItem', function () {
    describe('with a persisted item', function () {
      it('marks the item for destruction', function () {
        var item = { id: 1 };
        list.items.push(item);
        controller.removeItem(item);
        expect(controller.list.items).toEqual([{ id: 1, _destroy: '1' }]);
      });
    });

    describe('with a new item', function () {
      it('removes the item', function () {
        var item = { quantity: 1 };
        list.items.push(item);
        controller.removeItem(item);
        expect(controller.list.items).toEqual([]);
      });
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
