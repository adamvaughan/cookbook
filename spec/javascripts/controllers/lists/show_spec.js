/* global describe, beforeEach, it, expect, spyOn, inject */

'use strict';

describe('Controller: ListCtrl', function () {
  var controller;
  var rootScope;
  var location;
  var q;
  var lists;
  var plan;
  var list;

  beforeEach(module('cookbook'));

  beforeEach(inject(function ($controller, $rootScope, $location, $q, Lists) {
    rootScope = $rootScope;
    location = $location;
    q = $q;
    lists = Lists;
    plan = { id: 1, month: 8, year: 2014 };
    list = { id: 2, items: [] };
    controller = $controller('ListCtrl', { plan: plan, list: list });
  }));

  describe('initialization', function () {
    it('sets the plan', function () {
      expect(controller.plan).toEqual(plan);
    });

    it('sets the list', function () {
      expect(controller.list).toEqual(list);
    });
  });

  describe('deleteList', function () {
    it('shows the confirmation dialog', function () {
      controller.deletePromptVisible = false;
      controller.deleteList();
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
    it('deletes the list', function () {
      spyOn(lists, 'delete').andReturn(q.when([]));
      spyOn(location, 'path');

      controller.confirmDelete();
      expect(lists.delete).toHaveBeenCalledWith(plan);

      rootScope.$apply();
      expect(location.path).toHaveBeenCalledWith('/plans/1');
    });
  });

  describe('regenerateShoppingList', function () {
    it('deletes and fetches the list', function () {
      spyOn(lists, 'delete').andReturn(q.when([]));
      spyOn(lists, 'get').andReturn(q.when({ id: 1 }));

      controller.regenerateShoppingList();
      expect(lists.delete).toHaveBeenCalledWith(plan);

      rootScope.$apply();
      expect(lists.get).toHaveBeenCalledWith(1);
      expect(controller.list).toEqual({ id: 1 });
    });
  });

  describe('saveList', function () {
    it('saves the list', function () {
      spyOn(lists, 'save');
      controller.saveList();
      expect(lists.save).toHaveBeenCalled();
    });
  });
});
