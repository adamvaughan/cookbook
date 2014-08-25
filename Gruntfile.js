'use strict';

module.exports = function (grunt) {
  require('load-grunt-tasks')(grunt);

  grunt.initConfig({
    jshint: {
      options: {
        reporter: require('jshint-stylish'),
        jshintrc: '.jshintrc'
      },
      js: {
        src: [
          'Gruntfile.js',
          'app/assets/javascripts/**/*.js'
        ]
      },
      tests: {
        src: [
          'spec/javascripts/**/*.js'
        ]
      }
    },

    karma: {
      unit: {
        configFile: 'karma.conf.js',
        singleRun: true
      },
      watch: {
        configFile: 'karma.conf.js',
        autoWatch: true
      }
    }
  });

  grunt.registerTask('default', [
    'jshint',
    'karma:unit'
  ]);
};
