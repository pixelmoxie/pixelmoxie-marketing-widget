# https://github.com/vojtajina/grunt-coffeelint
module.exports = ( grunt, config ) ->
  app:
    options:
      max_line_length:
        value: 120
        level: 'warn'
    files:
      src: [
        '<%= files.coffee %>'
      ]
