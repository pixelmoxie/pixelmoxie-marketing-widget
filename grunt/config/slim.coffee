# https://github.com/matsumos/grunt-slim
module.exports = ( grunt, config ) ->
  data:
    options:
      pretty: false
      option: [
        'indent="\t"',
        'sort_attrs=false'
      ]
    files:
      '<%= paths.dist %>data.xml': '<%= paths.data %>data.xml.slim'
