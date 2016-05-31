# https://github.com/sindresorhus/grunt-sass
module.exports = ( grunt, config ) ->
  options:
    includePaths: require( 'node-bourbon' ).includePaths
    sourceMap: false
    lineNumbers: false
    outputStyle: 'expanded'
    indentType: 'tab'
    indentWidth: 1
    functions:
      'uri-encode': ( val ) ->
        types = require( 'node-sass' ).types
        return (new types.String(encodeURIComponent(val.getValue())))

  widget:
    files: [
      expand: true
      cwd: '<%= paths.widgetAssets %>scss/'
      src: 'style.scss'
      dest: '<%= paths.tmp %>'
      ext: '.css'
    ]
