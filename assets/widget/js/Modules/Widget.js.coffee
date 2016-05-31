class PMXMW.Widget extends pmxmwBackbone.View

  events: {}

  initialize: ->
    @$window = selectors.get window
    @$body   = selectors.get 'body'

    @dataURL      = "https://cdn.rawgit.com/pixelmoxie/pixelmoxie-marketing-widget/7b578d6/dist/data.xml"
    @themeName    = window.themeInfo.name
    @themeVersion = window.themeInfo.version

    @isLivePreview = if (window.location.href.indexOf('/customize/') >= 0) then true else false
    @isFreeTheme   = @$body.hasClass( 'pixelmoxie-free-theme' )
    @showWidget    = @$body.hasClass( 'has-marketing-widget' )
    return

  render: ->
    unless @$body.hasClass( 'has-marketing-widget' )
      @$body.addClass 'has-marketing-widget'

    ajaxQuery = "SELECT features-title, support-title, settings-title, themes.theme from xml WHERE url=\"#{@dataURL}\" and themes.theme.title=\"#{@themeName}\""
    ajaxURL = "http://query.yahooapis.com/v1/public/yql?q=" + encodeURIComponent( ajaxQuery ) + "&format=json&callback=?"

    $.ajax
      url: ajaxURL
      dataType: 'jsonp'
      type: 'GET'
      cache: true
      success: ( res, status ) ->
        if status is "success" or status is "notmodified"
          data = res.query.results.data
          console.log data
        return
    return
