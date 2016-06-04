# https://github.com/vojtajina/grunt-coffeelint
module.exports = ( grunt, config ) ->
  app:
    options:
      no_nested_string_interpolation:
        level: 'ignore'
      max_line_length:
        value: 120
        level: 'warn'
    files:
      src: [
        '<%= files.coffee %>'
      ]
