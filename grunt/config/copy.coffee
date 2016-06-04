# https://github.com/gruntjs/grunt-contrib-copy
module.exports = ( grunt, config ) ->
  bowerjs:
    files: [
      {
        expand: true
        flatten: true
        cwd: 'bower_components/'
        src: [
          'underscore/underscore.js'
          'backbone/backbone.js'
          'jquery.transit/jquery.transit.js'
          'loadcss/src/loadCSS.js'
          'loadcss/src/onloadCSS.js'
        ]
        dest: '<%= paths.concat %>'
      }
    ]

  css:
    files: [
      {
        expand: true
        flatten: true
        cwd: '<%= paths.tmp %>'
        src: [
          'style*.css'
        ]
        dest: '<%= paths.dist %>'
        filter: 'isFile'
        rename: ( dest, src ) ->
          dest + src.replace 'style', 'pmxmw'
      }
    ]
