# https://github.com/gruntjs/grunt-contrib-uglify
module.exports = ( grunt, config ) ->
  scripts:
    options:
      sourceMap: false
      mangle:
        except: [
          'jQuery'
          'Backbone'
          'Underscore'
        ]
      beautify: false
      compress: true
      sourceMapIncludeSources: true
    files: [
      expand: true
      cwd: '<%= paths.dist %>'
      src: [
        'pmxmw.js'
      ]
      dest: '<%= paths.dist %>'
      ext: '.min.js'
      extDot: 'last'
    ]
