module.exports = ( grunt, config ) ->

  # Build dependencies
  'build:dependencies': [
    'build:dependencies:js'
  ]

  'build:dependencies:js': [
    'bower_install'
    'copy:bowerjs'
    'clean:bowercomponents'
  ]

  # Build data
  'build:data': [
    'slim:data'
    'lineremover:data'
  ]

  # Build HTML
  'build:html': [
    'slim:html'
  ]

  # Build CSS
  'build:css': [
    'sass:widget'
    'postcss:widget'
    'replace:css'
    'copy:css'
    'postcss:min'
  ]

  # Build JavaScript
  'build:js': [
    'build:dependencies:js'
    'coffee'
    'concat:scripts'
    'uglify'
  ]

  # Build Tasks
  'build': [
    'clean:dist'
    'build:data'
    'build:html'
    'build:css'
    'build:js'
  ]

  # Check
  'check': [
    'scsslint'
    'coffeelint'
  ]

  # Default task
  default: [ 'watch' ]
