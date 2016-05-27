module.exports = ( grunt, config ) ->
  # Build data
  'build:data': [
    'clean:data'
    'slim:data'
    'lineremover:data'
  ]

  # Default task
  default: [ 'watch' ]
