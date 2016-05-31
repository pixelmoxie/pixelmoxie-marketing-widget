# https://github.com/gruntjs/grunt-contrib-connect
module.exports = ( grunt, config ) ->
  server:
    options:
      port: 8000
      base: '<%= paths.dist %>'
      keepalive: true
      livereload: true
      hostname: '127.0.0.1'
