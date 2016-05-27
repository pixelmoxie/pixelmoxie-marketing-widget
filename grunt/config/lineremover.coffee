# https://github.com/davidtucker/grunt-line-remover
module.exports = ( grunt, config ) ->
  data:
    options: {}
    files:
      '<%= paths.dist %>data.xml': '<%= paths.dist %>data.xml'
