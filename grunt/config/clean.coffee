# https://github.com/gruntjs/grunt-contrib-clean
module.exports = ( grunt, config ) ->
  bower: [
    '<%= paths.bower %>'
  ]

  bowercomponents: [
    'bower_components/'
  ]

  data: [
    '<%= paths.dist %>**/*.xml'
  ]

  dist: [
    '<%= paths.dist %>'
  ]

  tmp: [
    '<%= paths.tmp %>'
  ]
