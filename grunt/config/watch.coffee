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
