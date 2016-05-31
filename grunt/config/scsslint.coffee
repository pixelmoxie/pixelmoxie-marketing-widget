# https://github.com/ahmednuaman/grunt-scss-lint
module.exports = ( grunt, config ) ->
  options:
    config: '<%= paths.widgetAssets %>.scss-lint.yml'
    reporterOutput: null
  assets: [
    '<%= paths.widgetAssets %>scss/**/*.scss'
  ]
