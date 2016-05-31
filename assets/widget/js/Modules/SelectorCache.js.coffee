###
 * Keeps a cache of DOM objects
###
SelectorCache = ->
  collection = {}

  getFromCache = ( selector ) ->
    collection[ selector ] ?= ($ selector)
    collection[ selector ]

  clear = ( selector ) ->
    collection[ selector ] = undefined
    return

  getFresh = ( selector ) ->
    collection[ selector ] = undefined
    getFromCache( selector )

  {
    get:   getFromCache
    clear: clear
    fresh: getFresh
  }

# Our selector cache object
window.selectors = new SelectorCache()
