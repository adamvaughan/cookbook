/* global describe, beforeEach, it, expect, inject */

'use strict';

describe('Filter: ingredientDescription', function () {
  var ingredientDescription;

  beforeEach(module('cookbook'));

  beforeEach(inject(function ($filter) {
    ingredientDescription = $filter('ingredientDescription');
  }));

  describe('when only a measurement is given', function () {
    it('returns the measurement', function () {
      expect(ingredientDescription({ measurement: 'cup' })).toEqual('cup');
    });
  });

  describe('when a measurement and description are given', function () {
    it('returns the measurement and description', function () {
      expect(ingredientDescription({ measurement: 'cup', description: 'milk' })).toEqual('cup milk');
    });
  });

  describe('when a measurement, description, and notes are given', function () {
    it('returns the measurement, description, and notes', function () {
      expect(ingredientDescription({ measurement: 'cup', description: 'milk', notes: '2% fat' })).toEqual('cup milk, 2% fat');
    });
  });

  describe('when a measurement and notes are given', function () {
    it('returns the measurement and notes', function () {
      expect(ingredientDescription({ measurement: 'cup', notes: '2% fat' })).toEqual('cup, 2% fat');
    });
  });

  describe('when a description and notes are given', function () {
    it('returns the description and notes', function () {
      expect(ingredientDescription({ description: 'milk', notes: '2% fat' })).toEqual('milk, 2% fat');
    });
  });
});
