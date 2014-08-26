/* global describe, beforeEach, it, expect, inject */

'use strict';

describe('Service: Menu', function () {
  var service;

  beforeEach(module('cookbook'));

  beforeEach(inject(function (Menu) {
    service = Menu;
  }));

  describe('initialization', function () {
    it('hides the menu by default', function () {
      expect(service.show).toBeFalsy();
    });
  });

  describe('openMenu', function () {
    it('displays the menu', function () {
      service.openMenu();
      expect(service.show).toBeTruthy();
    });
  });

  describe('closeMenu', function () {
    it('hides the menu', function () {
      service.show = true;
      service.closeMenu();
      expect(service.show).toBeFalsy();
    });
  });
});
