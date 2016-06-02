# https://github.com/gruntjs/grunt-contrib-concat
module.exports = ( grunt, config ) ->
  scripts:
    src: [
      '<%= paths.concat %>underscore.js'
      '<%= paths.concat %>backbone.js'
      '<%= paths.concat %>jquery.transit.js'
      '<%= paths.tmp %>compiled.js'
    ]
    dest: '<%= paths.dist %>pmxmw.js'
