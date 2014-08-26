/* global describe, beforeEach, describe, it, expect, spyOn, inject */

'use strict';

describe('Service: Scroll', function () {
  var service;
  var rootScope;

  beforeEach(module('cookbook'));

  beforeEach(inject(function ($rootScope, Scroll) {
    service = Scroll;
    rootScope = $rootScope;
  }));

  describe('toBottom', function () {
    it('broadcasts an event', function () {
      spyOn(rootScope, '$broadcast');
      service.toBottom();
      expect(rootScope.$broadcast).toHaveBeenCalledWith('scrollBottom');
    });
  });
});
