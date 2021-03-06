# https://github.com/nDmitry/grunt-postcss
module.exports = ( grunt, config ) ->

  options:
    map: false

  widget:
    options:
      processors: [
        # require( 'postcss-autoreset' )({})
        require( 'postcss-initial' )({
          'reset': 'all'
          'replace': true
        })
        require( 'postcss-cssnext' )({})
        require( 'postcss-sorting' )({
          'sort-order': 'zen'
        })
        require( 'postcss-normalize-charset' )({})
      ]
    files:
      '<%= paths.tmp %>style.css' : '<%= paths.tmp %>style.css'

  min:
    options:
      processors: [
        require( 'cssnano' )({
          safe: true
          discardComments:
            removeAll: true
        })
      ]
    files:
      '<%= paths.tmp %>style.min.css' : '<%= paths.tmp %>style.css'
