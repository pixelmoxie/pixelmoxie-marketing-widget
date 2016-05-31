# https://github.com/gruntjs/grunt-contrib-watch
module.exports = ( grunt, config ) ->
  configFiles:
    options:
      reload: true
    files: [
      'Gruntfile.coffee'
      '<%= paths.config %>**/*'
    ]

  data:
    files: [
      '<%= paths.data %>data.xml.slim'
    ]
    tasks: [
      'slim:data'
      'lineremover:data'
    ]

  'livereload:html':
    options:
      livereload: true
    files: [
      '<%= paths.widgetAssets %>html/index.html.slim'
    ]
    tasks: [
      'slim:html'
    ]

  'livereload:scss':
    options:
      livereload: true
    files: [
      '<%= files.scss %>'
    ]
    tasks: [
      'sass:widget'
      'postcss:widget'
      'replace:css'
      'copy:css'
      'postcss:min'
    ]

  'livereload:js':
    options:
      livereload: true
    files: [
      '<%= paths.js %>**/*.coffee'
    ]
    tasks: [
      'coffee'
      'concat:scripts'
    ]
