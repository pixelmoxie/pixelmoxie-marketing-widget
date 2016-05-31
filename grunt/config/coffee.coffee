# https://github.com/gruntjs/grunt-contrib-coffee
module.exports = ( grunt, config ) ->
  compile:
    options:
      bare: false
      join: false
    files:
      '<%= paths.tmp %>compiled.js': [
        '<%= paths.widgetAssets %>js/scripts.js.coffee'
        '<%= paths.widgetAssets %>js/Modules/SelectorCache.js.coffee'
        '<%= paths.widgetAssets %>js/Modules/Widget.js.coffee'
        '<%= paths.widgetAssets %>js/Modules/App.js.coffee'
      ]
