/**
 * Called from gulpfile.js
 */

module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('./_public/package.json'),
    nodewebkit: {
      options: {
        version: "0.9.2",
        build_dir: './dist',
        // specify what to build
        mac: true,
        win: true,
        linux32: true,
        linux64: true
      },
      src: './_public/**/*'
    }
  });

  grunt.loadNpmTasks('grunt-node-webkit-builder');
};
