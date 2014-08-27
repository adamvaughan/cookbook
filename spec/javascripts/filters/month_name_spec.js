/* global describe, beforeEach, it, expect, inject */

'use strict';

describe('Filter: monthName', function () {
  var monthName;

  beforeEach(module('cookbook'));

  beforeEach(inject(function ($filter) {
    monthName = $filter('monthName');
  }));

  it('returns the name of the month', function () {
    expect(monthName(0)).toEqual('January');
    expect(monthName(1)).toEqual('February');
    expect(monthName(2)).toEqual('March');
    expect(monthName(3)).toEqual('April');
    expect(monthName(4)).toEqual('May');
    expect(monthName(5)).toEqual('June');
    expect(monthName(6)).toEqual('July');
    expect(monthName(7)).toEqual('August');
    expect(monthName(8)).toEqual('September');
    expect(monthName(9)).toEqual('October');
    expect(monthName(10)).toEqual('November');
    expect(monthName(11)).toEqual('December');
  });
});
